import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';
import 'package:legacy_sync/features/livekit_connection/domain/usecases/livekit_connection_usecases.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/participant_info.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/livekit_api.dart';
import 'livekit_connection_state.dart';

class LiveKitConnectionCubit extends Cubit<LiveKitConnectionState> {
  LiveKitConnectionUseCases liveKitUseCase = LiveKitConnectionUseCases();
  Timer? _timer;
  Timer? _speakerSortTimer;
  Timer? _remoteTimer;
  static const String livekitUrl = "wss://lagecy-87n09bcj.livekit.cloud";

  Room? _room;
  EventsListener<RoomEvent>? _listener;

  List<FriendsDataList> users = const [];
  List<PodcastTopicsModel> topicsList = [];

  LiveKitConnectionCubit() : super(const LiveKitConnectionState());

  String _displayNameFromLiveKit(String nameOrIdentity) {
    // you are sending: "$userName__$userId"
    final parts = nameOrIdentity.split('__');
    return parts.isNotEmpty ? parts.first : nameOrIdentity;
  }

  int? _userIdFromLiveKit(String nameOrIdentity) {
    final parts = nameOrIdentity.split('__');
    if (parts.length >= 2) return int.tryParse(parts.last);
    return null;
  }

  void _applyRemoteRecordingState(
    LiveKitRecordingStatus recordStatus,
    Duration duration,
  ) {
    // Invitee should follow host state
    // (Host will also receive, but that’s okay—this keeps them consistent)
    _remoteTimer?.cancel();
    _remoteTimer = null;

    if (recordStatus == LiveKitRecordingStatus.recording) {
      // Start ticking locally so invitee timer moves
      _remoteTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        emit(
          state.copyWith(duration: state.duration + const Duration(seconds: 1)),
        );
      });
    }

    emit(state.copyWith(recordingStatus: recordStatus, duration: duration));
  }

  void _startSortLoop() {
    _speakerSortTimer?.cancel();
    _speakerSortTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      sortParticipants();
    });
  }

  void _stopSortLoop() {
    _speakerSortTimer?.cancel();
    _speakerSortTimer = null;
  }

  Future<void> connect({
    required String roomId,
    required String userName,
    required int userId,
  }) async {
    if (state.status == LiveKitStatus.connecting) return;

    emit(
      state.copyWith(
        status: LiveKitStatus.connecting,
        message: "Requesting microphone permission...",
        roomId: roomId,
        myUserId: userId,
        myUserName: userName,
      ),
    );

    try {
      await _checkMicPermission();

      emit(state.copyWith(message: "Getting token..."));
      final participantName = "${userName.trim()}__$userId";

      final tokenEither = await liveKitUseCase.fetchParticipantToken(
        roomId: roomId,
        participantName: participantName,
      );

      late final String token;
      tokenEither.fold(
        (error) => throw Exception(error.message ?? "Failed to get token"),
        (t) => token = t,
      );

      // create audio track
      emit(state.copyWith(message: "Preparing microphone..."));
      final audioTrack = await LocalAudioTrack.create(
        const AudioCaptureOptions(),
      );
      await audioTrack.start();

      final room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultAudioPublishOptions: AudioPublishOptions(name: 'podcast_mic'),
        ),
      );

      final listener = room.createListener();
      _room = room;
      _listener = listener;

      _bindRoomEvents(room, listener);

      emit(state.copyWith(message: "Connecting to room..."));

      await room.connect(
        livekitUrl,
        token,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(track: audioTrack),
        ),
      );

      final needsConfirm = room.engine.fastConnectOptions == null;

      emit(
        state.copyWith(
          status: LiveKitStatus.connected,
          message: null,
          room: room,
          listener: listener,
          callStatus: CallStatus.connected,
          needsPublishConfirm: needsConfirm,
        ),
      );
      if (state.myUserId != null && state.myUserName != null) {
        _syncParticipantsFromRoom(
          myUserId: state.myUserId!,
          myUserName: state.myUserName!,
        );
      }
      sortParticipants();
      _startSortLoop();
    } catch (e) {
      await disconnect();
      print("Call Is Disconnected");
      emit(
        state.copyWith(
          status: LiveKitStatus.failure,
          message: e.toString(),
          callStatus: CallStatus.idle,
        ),
      );
    }
  }

  Future<void> enableMic() async {
    try {
      await _room?.localParticipant?.setMicrophoneEnabled(true);
      emit(state.copyWith(isMic: true));
    } catch (_) {}
  }

  void clearPublishConfirm() {
    emit(state.copyWith(needsPublishConfirm: false));
  }

  Future<void> handleWindowShouldClose() async {
    final listener = _listener;
    final room = _room;

    try {
      unawaited(room?.disconnect());
      if (listener != null) {
        await listener.waitFor<RoomDisconnectedEvent>(
          duration: const Duration(seconds: 5),
        );
      }
    } catch (_) {}
  }

  void _bindRoomEvents(Room room, EventsListener<RoomEvent> listener) {
    listener
      ..on<RoomDisconnectedEvent>((event) {
        unawaited(disconnect());
        // emit(state.copyWith(callStatus: CallStatus.disconnected));
      })
      ..on<ParticipantEvent>((event) {
        sortParticipants();
        if (state.myUserId != null && state.myUserName != null) {
          _syncParticipantsFromRoom(
            myUserId: state.myUserId!,
            myUserName: state.myUserName!,
          );
        }
      })
      ..on<RoomRecordingStatusChanged>((event) {
        emit(
          state.copyWith(
            showRecordingStatusDialog: true,
            activeRecording: event.activeRecording,
          ),
        );
      })
      ..on<RoomAttemptReconnectEvent>((event) {
        print(
          'Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
          '(${event.nextRetryDelaysInMs}ms delay until next attempt)',
        );
      })
      ..on<LocalTrackSubscribedEvent>((event) {
        print('Local track subscribed: ${event.trackSid}');
      })
      ..on<LocalTrackPublishedEvent>((_) => sortParticipants())
      ..on<LocalTrackUnpublishedEvent>((_) => sortParticipants())
      ..on<TrackSubscribedEvent>((_) => sortParticipants())
      ..on<TrackUnsubscribedEvent>((_) => sortParticipants())
      ..on<TrackE2EEStateEvent>(_onE2EEStateEvent)
      ..on<ParticipantNameUpdatedEvent>((event) {
        print(
          'Participant name updated: ${event.participant.identity}, name => ${event.name}',
        );
        sortParticipants();
      })
      ..on<ParticipantMetadataUpdatedEvent>((event) {
        print(
          'Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}',
        );
      })
      ..on<RoomMetadataChangedEvent>((event) {
        print('Room metadata changed: ${event.metadata}');
      })
      ..on<DataReceivedEvent>((event) async {
        String decoded = '';
        try {
          decoded = utf8.decode(event.data);
        } catch (err) {
          return;
        }

        // Try parse JSON
        try {
          final map = jsonDecode(decoded);
          if (map is Map && map["type"] == "rec_state") {
            final statusStr = (map["status"] ?? "").toString();
            final durMs =
                int.tryParse((map["duration_ms"] ?? "0").toString()) ?? 0;

            final newStatus = LiveKitRecordingStatus.values.firstWhere(
              (e) => e.name == statusStr,
              orElse: () => LiveKitRecordingStatus.idle,
            );

            _applyRemoteRecordingState(
              newStatus,
              Duration(milliseconds: durMs),
            );
            return;
          }
          // ✅ call ended by other user
          if (map["type"] == "call_end") {
            // Prevent repeated actions
            if (state.isHost) return;

            if (state.callStatus == CallStatus.disconnected) return;

            // This will trigger your UI listener navigation (pop/replace)
            await disconnect();
            return;
          }
        } catch (_) {
          // Not JSON, ignore or keep your existing dataReceivedText flow if needed
        }

        // If you still want your old "showDataReceivedDialog"
        emit(state.copyWith(dataReceivedText: decoded));
      })
      ..on<AudioPlaybackStatusChanged>((event) async {
        final room = _room;
        if (room == null) return;

        if (!room.canPlaybackAudio) {
          emit(state.copyWith(showPlayAudioManuallyDialog: true));
        }
      })
      ..on<ParticipantConnectedEvent>((e) {
        if (state.myUserId != null && state.myUserName != null) {
          _syncParticipantsFromRoom(
            myUserId: state.myUserId!,
            myUserName: state.myUserName!,
          );
        }
        if (state.isHost == true) {
          _broadcastRecordingState();
        }
      })
      ..on<ParticipantDisconnectedEvent>((e) {
        if (state.myUserId != null && state.myUserName != null) {
          _syncParticipantsFromRoom(
            myUserId: state.myUserId!,
            myUserName: state.myUserName!,
          );
        }
        // now check count from *state.participants after sync*
        final count = currentCountFromRoom();

        if (count <= 1 && state.callStatus != CallStatus.disconnected) {
          if (!state.isHost) {
            unawaited(disconnect()); // invitee leaves room automatically
          }
        }
      });
  }

  int currentCountFromRoom() {
    final room = _room;
    if (room == null) return 0;
    return 1 + room.remoteParticipants.length; // local + remote
  }

  void setConsent(bool value) {
    emit(state.copyWith(consentGiven: value));
  }

  Future<void> startAudioPlayback() async {
    final room = _room;
    if (room == null) return;
    await room.startAudio();
  }

  void clearUiEvents() {
    emit(
      state.copyWith(
        showRecordingStatusDialog: null,
        activeRecording: null,
        dataReceivedText: null,
        showPlayAudioManuallyDialog: null,
      ),
    );
  }

  void setHost(bool isHost) {
    emit(state.copyWith(isHost: isHost));
  }

  void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
    print('e2ee state: $e2eeState');
  }

  Future<void> disconnect() async {
    try {
      await _listener?.dispose();
    } catch (_) {}
    _listener = null;

    try {
      await _room?.disconnect();
      await _room?.dispose();
    } catch (_) {}
    _room = null;

    _timer?.cancel();
    _timer = null;
    _remoteTimer?.cancel();
    _remoteTimer = null;

    emit(
      state.copyWith(
        callStatus: CallStatus.disconnected,
        room: null,
        listener: null,
        participantTracks: const [],
        needsPublishConfirm: false,
        showRecordingStatusDialog: null,
        activeRecording: null,
        dataReceivedText: null,
        showPlayAudioManuallyDialog: null,
        myUserId: null,
        myUserName: null,
      ),
    );
    _stopSortLoop();
  }

  Future<void> _checkMicPermission() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) throw Exception("Microphone permission denied");
  }

  Future<void> micONOff() async {
    final room = _room;
    if (room == null) {
      emit(state.copyWith(isMic: !(state.isMic ?? true)));
      return;
    }

    final enabledNow = !(state.isMic ?? true);
    try {
      await room.localParticipant?.setMicrophoneEnabled(enabledNow);
    } catch (_) {}

    emit(state.copyWith(isMic: enabledNow));
  }

  Future<void> speakerONOff() async {
    final enabledNow = !(state.isSpeaker ?? true);

    try {
      if (lkPlatformIs(PlatformType.android)) {
        await Hardware.instance.setSpeakerphoneOn(enabledNow);
      }
    } catch (_) {}

    emit(state.copyWith(isSpeaker: enabledNow));
  }

  Set<int> _recomputeInvitedIds({
    required Set<int> currentInvited,
    required List<FriendsDataList> currentParticipants,
  }) {
    final joinedIds =
        currentParticipants.map((p) => p.userIdPK).whereType<int>().toSet();

    // If someone is in the room, they are no longer "invited"
    final updated = <int>{};
    for (final id in currentInvited) {
      if (!joinedIds.contains(id)) {
        updated.add(id);
      }
    }
    return updated;
  }

  void sortParticipants() {
    final room = _room;
    if (room == null) return;

    final userTracks = <ParticipantTrack>[];
    final screenTracks = <ParticipantTrack>[];

    for (var participant in room.remoteParticipants.values) {
      // Screen share video
      for (var t in participant.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(
            ParticipantTrack(
              participant: participant,
              type: ParticipantTrackType.kScreenShare,
            ),
          );
        }
      }

      // Add participant even if only audio exists
      final hasAnyVideo = participant.videoTrackPublications.any(
        (t) => !t.isScreenShare,
      );
      final hasAudio = participant.audioTrackPublications.isNotEmpty;

      if (hasAnyVideo || hasAudio) {
        userTracks.add(ParticipantTrack(participant: participant));
      }
    }

    // Local participant
    final lp = room.localParticipant;
    if (lp != null) {
      final hasAnyVideo = lp.videoTrackPublications.any(
        (t) => !t.isScreenShare,
      );
      final hasAudio = lp.audioTrackPublications.isNotEmpty;

      if (hasAnyVideo || hasAudio) {
        userTracks.add(ParticipantTrack(participant: lp));
      }

      // Add local screen share tile if any
      for (var t in lp.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(
            ParticipantTrack(
              participant: lp,
              type: ParticipantTrackType.kScreenShare,
            ),
          );
        }
      }
    }

    // Keep your sorting logic (but handle if audio-only)
    userTracks.sort((a, b) {
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        return a.participant.audioLevel > b.participant.audioLevel ? -1 : 1;
      }

      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      if (aSpokeAt != bSpokeAt) return aSpokeAt > bSpokeAt ? -1 : 1;

      // Prefer people who have video (if any) but audio-only works too
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    emit(state.copyWith(participantTracks: [...screenTracks, ...userTracks]));
  }

  Future<void> fetchPodcastTopics() async {
    TopicCategory category = TopicCategory.relationship;

    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final mypodcast = await liveKitUseCase.getPodcastTopic(userId);

    mypodcast.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        Utils.closeLoader();
        if (result.data != null) {
          print("DATA ON SUCCESS:: ${result.data}");
          topicsList.clear();
          result.data.forEach((element) {
            if (element.topicType == 1) {
              category = TopicCategory.relationship;
            } else {
              category = TopicCategory.family;
            }
            topicsList.add(
              PodcastTopicsModel(
                title: element.topic,
                description: element.topic,
                id: element.id.toString(),
                category: category,
              ),
            );
          });
          emit(state.copyWith(isLoading: false));
        } else {
          emit(
            state.copyWith(isLoading: false, error: "No profile data found"),
          );
        }
      },
    );
    loadTopics();
  }

  void resetInviteStatus() {
    emit(state.copyWith(inviteStatus: InviteStatus.idle, inviteMessage: null));
  }

  Future<void> inviteFriend(FriendsDataList friend) async {
    final myUserId = await AppPreference().getInt(
      key: AppPreference.KEY_USER_ID,
    );

    if (friend.userIdPK == null) {
      emit(
        state.copyWith(
          inviteStatus: InviteStatus.failure,
          inviteMessage: "Unable to invite friend",
        ),
      );
      return;
    }

    if (state.roomId == null) {
      emit(
        state.copyWith(
          inviteStatus: InviteStatus.failure,
          inviteMessage: "Something went wrong, Try again",
        ),
      );
      return;
    }

    // Optional: show progress message
    emit(
      state.copyWith(
        inviteStatus: InviteStatus.sending,
        inviteMessage: null,
        invitingFriendId: friend.userIdPK,
      ),
    );

    final res = await liveKitUseCase.inviteFriendToPodcast(
      userId: myUserId,
      friendId: friend.userIdPK!,
      roomId: state.roomId!,
    );

    res.fold(
      (error) {
        emit(
          state.copyWith(
            inviteStatus: InviteStatus.failure,
            inviteMessage: error.message ?? "Invite failed",
            invitingFriendId: null,
          ),
        );
      },
      (result) {
        // addParticipant(friend);

        final updated = Set<int>.from(state.invitedFriendIds);
        updated.add(friend.userIdPK!); // ✅ store invited friend id
        // updated.add(result.invitedFriendId); // ✅ store invited friend id

        emit(
          state.copyWith(
            inviteStatus: InviteStatus.success,
            inviteMessage: result.message,
            invitedFriendIds: updated,
            invitingFriendId: null,
          ),
        );
      },
    );
  }

  void loadTopics() {
    final familyTopics =
        topicsList.where((t) => t.category == TopicCategory.family).toList();

    emit(
      state.copyWith(
        allTopics: topicsList,
        filteredTopics: familyTopics,
        selectedCategory: TopicCategory.family,
        currentTopicIndex: 0,
      ),
    );
  }

  void addParticipant(FriendsDataList user) {
    emit(
      state.copyWith(
        callStatus: CallStatus.connected,
        participants: [...state.participants, user],
      ),
    );
  }

  void getInviteUse() {
    emit(state.copyWith(inviteUserList: users));
  }

  Future<void> startRecording() async {
    if (!state.isHost) return;
    final uid = state.myUserId;
    final rid = state.roomId;
    if (uid == null || rid == null) return;

    // call backend first
    final res = await liveKitUseCase.startRecording(userId: uid, roomId: rid);

    res.fold(
      (error) {
        emit(
          state.copyWith(
            inviteStatus: InviteStatus.failure,
            inviteMessage: error.message ?? "Start recording failed",
          ),
        );
      },
      (data) async {
        emit(state.copyWith(recordingStatus: LiveKitRecordingStatus.recording));
        _startTimer();
        await _broadcastRecordingState();
      },
    );
  }

  void pauseRecording() {
    _timer?.cancel();
    emit(state.copyWith(recordingStatus: LiveKitRecordingStatus.paused));
    _broadcastRecordingState();
  }

  void resumeRecording() {
    emit(state.copyWith(recordingStatus: LiveKitRecordingStatus.recording));
    _startTimer();
    _broadcastRecordingState();
  }

  void stopRecording() async {
    if (!state.isHost) return;
    final rid = state.roomId;
    if (rid == null) return;

    final res = await liveKitUseCase.stopRecording(roomId: rid);

    res.fold(
      (error) {
        emit(state.copyWith(recordingStatus: LiveKitRecordingStatus.recording, error: error.message));
      },
      (data) async {
        _timer?.cancel();
        _timer = null;
        _remoteTimer?.cancel();
        _remoteTimer = null;

        emit(state.copyWith(recordingStatus: LiveKitRecordingStatus.completed));
        await _broadcastRecordingState();
      },
    );
  }

  /// 🔹 NEXT
  void nextTopic() {
    if (state.currentTopicIndex < state.filteredTopics.length - 1) {
      emit(state.copyWith(currentTopicIndex: state.currentTopicIndex + 1));
    }
  }

  /// 🔹 PREVIOUS
  void previousTopic() {
    if (state.currentTopicIndex > 0) {
      emit(state.copyWith(currentTopicIndex: state.currentTopicIndex - 1));
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(duration: state.duration + const Duration(seconds: 1)),
      );
    });
  }

  /// 🔹 FILTER BY CATEGORY
  void filterByCategory(TopicCategory category) {
    final filtered =
        state.allTopics.where((t) => t.category == category).toList();

    emit(
      state.copyWith(
        filteredTopics: filtered,
        selectedCategory: category,
        shuffle: false,
        currentTopicIndex: 0,
      ),
    );
  }

  /// 🔹 SHUFFLE
  void shuffleTopics(TopicCategory category) {
    final shuffled = List<PodcastTopicsModel>.from(state.allTopics)..shuffle();

    emit(
      state.copyWith(
        filteredTopics: shuffled,
        selectedCategory: category,
        currentTopicIndex: 0,
      ),
    );
  }

  void _syncParticipantsFromRoom({
    required int myUserId,
    required String myUserName,
  }) {
    final room = _room;
    if (room == null) return;

    final merged = <FriendsDataList>[];

    void addMerged(FriendsDataList p) {
      final id = p.userIdPK;
      final exists =
          id != null
              ? merged.any((x) => x.userIdPK == id)
              : merged.any((x) => x.firstName == p.firstName);
      if (!exists) merged.add(p);
    }

    // local
    addMerged(
      FriendsDataList(
        userIdPK: myUserId,
        firstName: myUserName,
        profileImage: null,
      ),
    );

    // remote
    for (final p in room.remoteParticipants.values) {
      final raw = (p.name?.isNotEmpty == true) ? p.name! : p.identity;
      addMerged(
        FriendsDataList(
          userIdPK: _userIdFromLiveKit(raw),
          firstName: _displayNameFromLiveKit(raw),
          profileImage: null,
        ),
      );
    }

    final updatedInvites = _recomputeInvitedIds(
      currentInvited: state.invitedFriendIds,
      currentParticipants: merged,
    );

    emit(
      state.copyWith(participants: merged, invitedFriendIds: updatedInvites),
    );
  }

  Future<void> endCall() async {
    if(state.recordingStatus != LiveKitRecordingStatus.idle){
      stopRecording();
    }
    if (state.isHost) {
      await _broadcastCallEnd();
    }
    await disconnect(); // important
  }

  Future<void> _broadcastRecordingState() async {
    final room = _room;
    if (room == null) return;

    // You are using Duration in state already
    final payload = {
      "type": "rec_state",
      "status": state.recordingStatus.name, // idle/recording/paused/completed
      "duration_ms": state.duration.inMilliseconds,
    };

    final bytes = utf8.encode(jsonEncode(payload));

    try {
      await room.localParticipant?.publishData(bytes, reliable: true);
    } catch (_) {}
  }

  Future<void> _broadcastCallEnd() async {
    final room = _room;
    if (room == null) return;

    final payload = {"type": "call_end"};
    final bytes = utf8.encode(jsonEncode(payload));

    try {
      await room.localParticipant?.publishData(bytes, reliable: true);
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await disconnect();
    _stopSortLoop();
    return super.close();
  }
}
