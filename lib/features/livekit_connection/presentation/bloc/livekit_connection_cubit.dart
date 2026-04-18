import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/navigation_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';
import 'package:legacy_sync/features/livekit_connection/domain/usecases/livekit_connection_usecases.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/participant_info.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'livekit_connection_state.dart';

class LiveKitConnectionCubit extends Cubit<LiveKitConnectionState> {
  LiveKitConnectionUseCases liveKitUseCase = LiveKitConnectionUseCases();
  Timer? _timer;
  Timer? _speakerSortTimer;
  Timer? _remoteTimer;
  Timer? _netFallbackTimer;

  Room? _room;
  EventsListener<RoomEvent>? _listener;
  List<FriendsDataList> users = const [];

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
        if (isClosed) return;
        _safeEmit(state.copyWith(duration: state.duration + const Duration(seconds: 1)));
      });
    }
    _safeEmit(state.copyWith(recordingStatus: recordStatus, duration: duration));
  }

  void _startSortLoop() {
    _speakerSortTimer?.cancel();
    _speakerSortTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      sortParticipants();
    });
  }

  Future<void> connect({
    required String roomId,
    required String userName,
    required int userId,
  }) async {
    if (state.status == LiveKitStatus.connecting) return;

    final shuffled = List<PodcastTopicsModel>.from(state.allTopics)..shuffle();

    emit(
      state.copyWith(
        showCallOverlay: false,
        status: LiveKitStatus.connecting,
        message: "Requesting microphone permission...",
        filteredTopics: shuffled,
        currentTopicIndex: 0,
        roomId: roomId,
        myUserId: userId,
        myUserName: userName,
        recordingStatus: LiveKitRecordingStatus.idle,
        duration: Duration.zero,
        everRecorded: false,
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
      final audioTrack = await LocalAudioTrack.create(const AudioCaptureOptions());
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
        ApiURL.livekitUrl,
        token,
        fastConnectOptions: FastConnectOptions(
          microphone: TrackOption(track: audioTrack),
        ),
      );

      // ✅ Mute initially if state says so
      if (!(state.isMic ?? false)) {
        await room.localParticipant?.setMicrophoneEnabled(false);
      }

      final needsConfirm = room.engine.fastConnectOptions == null;

      emit(
        state.copyWith(
          status: LiveKitStatus.connected,
          message: null,
          room: room,
          listener: listener,
          callStatus: CallStatus.connected,
          needsPublishConfirm: needsConfirm,
          // If I'm the host, persist my userId as the hostUserId right away
          hostUserId: state.isHost ? userId : state.hostUserId,
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

      // Broadcast host identity so all participants (even late joiners) know who the host is
      if (state.isHost) {
        await _broadcastHostInfo();
      }
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

  Future<void> _handleNetworkDisconnectFallback() async {
    _netFallbackTimer?.cancel();

    // wait 10-15 sec to see if it reconnects
    _netFallbackTimer = Timer(const Duration(seconds: 12), () async {
      if (isClosed) return;

      // if still offline or not connected -> exit cleanly
      final room = _room;
      final stillBad = room == null || state.netStatus != NetStatus.online;

      if (stillBad) {
        // invitee should go back; host too depending on your product
        await disconnect();

        if (isClosed) return;
        emit(
          LiveKitConnectionState.initial().copyWith(
            callStatus: CallStatus.disconnected,
            navEvent: const LiveKitNavEvent("MyPodcastScreen"),
          ),
        );
      }
    });
  }

  void _bindRoomEvents(Room room, EventsListener<RoomEvent> listener) {
    listener
      ..on<RoomDisconnectedEvent>((event) async {
        // If user intentionally ended call, ignore
        if (state.callStatus == CallStatus.disconnected) return;

        _timer?.cancel();
        _remoteTimer?.cancel();

        // network drop/disconnect
        _safeEmit(
          state.copyWith(
            netStatus: NetStatus.offline,
            netMessage: "Connection lost. Trying to recover...",
          ),
        );

        // If you want to AUTO EXIT after some time:
        await _handleNetworkDisconnectFallback();
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
        _safeEmit(
          state.copyWith(
            netStatus: NetStatus.reconnecting,
            netMessage: "Reconnecting... (${event.attempt}/${event.maxAttemptsRetry})",
            reconnectAttempt: event.attempt,
          ),
        );
      })
      ..on<RoomReconnectedEvent>((event) {
        // Back online
        _safeEmit(
          state.copyWith(
            netStatus: NetStatus.online,
            netMessage: null,
            reconnectAttempt: 0,
          ),
        );

        if (state.isHost && state.recordingStatus == LiveKitRecordingStatus.recording) {
          _startTimer();
        }

        // if host: re-broadcast state so invitee gets it again after reconnect
        if (state.isHost) {
          unawaited(_broadcastRecordingState());
        }
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
            final durMs = int.tryParse((map["duration_ms"] ?? "0").toString()) ?? 0;

            final newStatus = LiveKitRecordingStatus.values.firstWhere(
              (e) => e.name == statusStr,
              orElse: () => LiveKitRecordingStatus.idle,
            );

            _applyRemoteRecordingState(newStatus, Duration(milliseconds: durMs));
            return;
          }
          // ✅ call ended by other user
          if (map["type"] == "call_end") {
            if (state.isHost) return;
            await handleRemoteCallEnd();
            return;
          }
          // ✅ host identity broadcast — store so we can correctly show the Host badge
          if (map["type"] == "host_info") {
            final hId = int.tryParse((map["host_user_id"] ?? "").toString());
            if (hId != null && hId != 0) {
              _safeEmit(state.copyWith(hostUserId: hId));
            }
            return;
          }
        } catch (_) {}

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
          // Re-broadcast host info so the newly joined participant learns who the host is
          unawaited(_broadcastHostInfo());
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

  Future<void> handleRemoteCallEnd() async {
    if (state.callStatus == CallStatus.disconnected) return;

    // await _cleanupRoomOnly();

    // fully cleanup + reset
    await disconnect(); // this emits initial()

    if (isClosed) return;

    emit(
      LiveKitConnectionState.initial().copyWith(
        callStatus: CallStatus.disconnected,
        navEvent: const LiveKitNavEvent("MyPodcastScreen"),
      ),
    );
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
    emit(state.clearErrorAndUiEvents());
  }

  void clearError() {
    if (state.error != null) {
      emit(state.clearErrorAndUiEvents());
    }
  }

  void setHost(bool isHost) {
    emit(state.copyWith(isHost: isHost));
  }

  void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
    print('e2ee state: $e2eeState');
  }

  Future<void> _cleanupRoomOnly() async {
    _timer?.cancel();
    _timer = null;
    _remoteTimer?.cancel();
    _remoteTimer = null;
    _speakerSortTimer?.cancel();
    _speakerSortTimer = null;
    _netFallbackTimer?.cancel();
    _netFallbackTimer = null;

    try {
      await _listener?.dispose();
    } catch (_) {}
    _listener = null;

    try {
      await _room?.disconnect();
      await _room?.dispose();
    } catch (_) {}
    _room = null;
  }

  Future<void> disconnect() async {
    await _cleanupRoomOnly();
    if (isClosed) return;
    _safeEmit(LiveKitConnectionState.initial());
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
    final joinedIds = currentParticipants.map((p) => p.userIdPK).whereType<int>().toSet();

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
      final hasAnyVideo = participant.videoTrackPublications.any((t) => !t.isScreenShare);
      final hasAudio = participant.audioTrackPublications.isNotEmpty;

      if (hasAnyVideo || hasAudio) {
        userTracks.add(ParticipantTrack(participant: participant));
      }
    }

    // Local participant
    final lp = room.localParticipant;
    if (lp != null) {
      final hasAnyVideo = lp.videoTrackPublications.any((t) => !t.isScreenShare);
      final hasAudio = lp.audioTrackPublications.isNotEmpty;

      if (hasAnyVideo || hasAudio) {
        userTracks.add(ParticipantTrack(participant: lp));
      }

      // Add local screen share tile if any
      for (var t in lp.videoTrackPublications) {
        if (t.isScreenShare) {
          screenTracks.add(
            ParticipantTrack(participant: lp, type: ParticipantTrackType.kScreenShare),
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
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

    emit(state.copyWith(isLoading: true, error: null));

    final result = await liveKitUseCase.getPodcastTopic(userId);

    result.fold(
      (error) {
        debugPrint("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (res) {
        Utils.closeLoader();
        if (res.data != null) {
          final incoming = res.data; // List<PodcastTopic>

          final List<PodcastTopicsModel> built =
              incoming.map((element) {
                final TopicCategory category;
                switch (element.topicType) {
                  case 1:
                    category = TopicCategory.Beginnings;
                    break;
                  case 2:
                    category = TopicCategory.Bonds;
                    break;
                  case 3:
                    category = TopicCategory.Becoming;
                    break;
                  case 4:
                    category = TopicCategory.Hopes;
                    break;
                  case 5:
                  default:
                    category = TopicCategory.Remembrance;
                }

                return PodcastTopicsModel(
                  id: element.id.toString(),
                  title: element.topic,
                  description: element.topic,
                  category: category,
                );
              }).toList();
          final uniqueById = <String, PodcastTopicsModel>{};
          for (final t in built) {
            uniqueById[t.id] = t;
          }
          final uniqueList = uniqueById.values.toList();
          debugPrint("Topics from API: ${incoming.length}");
          debugPrint("Unique topics: ${uniqueList.length}");

          const defaultCategory = TopicCategory.Beginnings;
          final filtered =
              uniqueList.where((t) => t.category == defaultCategory).toList();

          emit(
            state.copyWith(
              isLoading: false,
              allTopics: uniqueList,
              filteredTopics: filtered,
              selectedCategory: defaultCategory,
              currentTopicIndex: 0,
            ),
          );
        } else {
          emit(state.copyWith(isLoading: false, error: "No profile data found"));
        }
      },
    );
  }

  void resetInviteStatus() {
    emit(state.copyWith(inviteStatus: InviteStatus.idle, inviteMessage: null));
  }

  Future<void> inviteFriend(FriendsDataList friend) async {
    final myUserId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

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
        final updated = Set<int>.from(state.invitedFriendIds);
        updated.add(friend.userIdPK!); // ✅ store invited friend id
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

  // void addParticipant(FriendsDataList user) {
  //   emit(
  //     state.copyWith(
  //       callStatus: CallStatus.connected,
  //       participants: [...state.participants, user],
  //     ),
  //   );
  // }

  void getInviteUse() {
    emit(state.copyWith(inviteUserList: users));
  }

  Future<void> startRecording() async {
    try {
      if (!state.isHost) return;
      if (state.isStartingRecording) return; // prevent double taps
      if (state.recordingStatus != LiveKitRecordingStatus.idle) return;
      final uid = state.myUserId;
      final rid = state.roomId;
      if (uid == null || rid == null) return;

      emit(state.copyWith(isStartingRecording: true, error: null));

      // call backend first
      final res = await liveKitUseCase.startRecording(userId: uid, roomId: rid);

      res.fold(
        (error) {
          emit(
            state.copyWith(
              recordingStatus: LiveKitRecordingStatus.idle,
              error: error.message,
              isStartingRecording: false,
            ),
          );
        },
        (data) async {
          emit(
            state.copyWith(
              recordingStatus: LiveKitRecordingStatus.recording,
              isStartingRecording: false,
              everRecorded: true,
              error: null,
            ),
          );
          _startTimer();
          await _broadcastRecordingState();
        },
      );
    } catch (e) {
      emit(state.copyWith(isStartingRecording: false, error: e.toString()));
    }
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

  Future<void> stopRecording() async {
    if (!state.isHost) return;
    if (isClosed) return;

    final rid = state.roomId;
    if (rid == null) return;

    try {
      final res = await liveKitUseCase.stopRecording(roomId: rid);
      if (isClosed) return;

      res.fold(
        (error) {
          if (isClosed) return;

          // keep status same, just show error
          _safeEmit(state.copyWith(error: error.message));
        },
        (data) async {
          if (isClosed) return;

          _timer?.cancel();
          _timer = null;
          _remoteTimer?.cancel();
          _remoteTimer = null;

          _safeEmit(
            state.copyWith(
              recordingStatus: LiveKitRecordingStatus.completed,
              error: null,
            ),
          );
          await _broadcastRecordingState();
        },
      );
    } catch (e) {
      if (isClosed) return;
      _safeEmit(state.copyWith(error: e.toString()));
    }
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
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isClosed) return;
      _safeEmit(state.copyWith(duration: state.duration + const Duration(seconds: 1)));
    });
  }

  /// 🔹 FILTER BY CATEGORY
  void filterByCategory(TopicCategory category) {
    final filtered = state.allTopics.where((t) => t.category == category).toList();

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

  void _syncParticipantsFromRoom({required int myUserId, required String myUserName}) {
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
      FriendsDataList(userIdPK: myUserId, firstName: myUserName, profileImage: null),
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

    emit(state.copyWith(participants: merged, invitedFriendIds: updatedInvites));
  }

  void _safeEmit(LiveKitConnectionState newState) {
    if (isClosed) return;
    emit(newState);
  }

  void clearNavEvent() => emit(state.copyWith(navEvent: LiveKitNavEvent.none));

  // Future<void> _cancelPendingInvites({
  //   required int userId,
  //   required String roomId,
  // }) async {
  //   // cancel invites for everyone who was invited and is still pending
  //   final futures = <Future>[];
  //
  //   for (final friendId in state.invitedFriendIds) {
  //     if (friendId == userId) continue;
  //
  //     futures.add(
  //       liveKitUseCase
  //           .cancelInviteToPodcast(userId: userId, friendId: friendId, roomId: roomId)
  //           .then((either) {
  //             debugPrint("Cancel invite result for $friendId: $either");
  //           }),
  //     );
  //   }
  //
  //   await Future.wait(futures);
  // }

  Future<void> endCall() async {
    final wasHost = state.isHost;
    final roomId = state.roomId;
    final selectedTopicCategory = state.selectedCategory;
    final filteredTopics = state.filteredTopics;

    final participants = List<FriendsDataList>.from(state.participants);
    final shouldGoPreview = wasHost && state.everRecorded;

    // ✅ you need your current user id
    final int userId = state.myUserId ?? 0;

    // Combine both invited friends AND actual participants just to be safe
    final currentParticipantIds = state.participants
        .where((p) => p.userIdPK != null && p.userIdPK != userId)
        .map((p) => p.userIdPK!)
        .toSet();

    final combinedFriends = <int>{...state.invitedFriendIds, ...currentParticipantIds};

    final success = await _broadcastCallEnd(
      userId: userId,
      friendId: combinedFriends,
      roomId: roomId ?? '',
    );
    if (!success) {
      return; // stay in the room, don't disconnect
    }

    // if (wasHost) {
    //
    // }

    if (state.recordingStatus == LiveKitRecordingStatus.recording ||
        state.recordingStatus == LiveKitRecordingStatus.paused) {
      await stopRecording();
    }

    await disconnect(); // important

    // decide navigation exactly like your RoomPage listener
    if (shouldGoPreview) {
      emit(
        state.copyWith(
          navEvent: LiveKitNavEvent(
            "AudioPreviewEditScreen",
            arguments: {
              "podcastModel": null,
              "is_draft": true,
              "participants":
                  participants.length - 1 == 1 ? participants[1].firstName : "",
              "roomId": roomId,
              "selectedTopicCategory": selectedTopicCategory.name.toString(),
              "filteredTopics": filteredTopics,
            },
          ),
        ),
      );
    } else {
      emit(state.copyWith(navEvent: const LiveKitNavEvent("MyPodcastScreen")));
    }
  }

  Future<bool> _broadcastCallEnd({
    required int userId,
    required Set<int> friendId,
    required String roomId,
  }) async {
    final room = _room;

    final payload = {"type": "call_end"};
    final bytes = jsonEncode(payload);
    final encodedBytes = utf8.encode(bytes);

    try {
      final response = await liveKitUseCase.endPodcastCall(
        userId: userId,
        friendId: friendId,
        roomId: roomId,
      );

      print("EndCall Response ::  ${response.toString()}");
      return response.fold(
        (error) {
          emit(state.copyWith(error: error.message));
          return false;
        },
        (data) async {
          emit(state.copyWith(isCallEnded: true, isCallEndMessage: data.message));
          if (room != null) {
            await room.localParticipant?.publishData(encodedBytes, reliable: true);
          }
          debugPrint("Podcast Call End Result For $friendId");
          return true;
        },
      );
    } catch (e) {
      debugPrint("Podcast call end result for $friendId: ${e.toString()}");
      emit(state.copyWith(error: e.toString()));
      return false;
    }
  }

  void syncInvitedFriends(List<dynamic> friends) {
    if (state.isHost) {
      final validIds = <int>{};
      for (final f in friends) {
        if (f.userIdPK != null &&
            (f.inPodcast?.toString() == '1' ||
                f.inviteStatus?.toString().toLowerCase() == 'invited')) {
          validIds.add(f.userIdPK!);
        }
      }
      emit(state.copyWith(invitedFriendIds: validIds));
    }
  }

  Future<void> _broadcastHostInfo() async {
    final room = _room;
    if (room == null) return;
    final hId = state.hostUserId ?? state.myUserId;
    if (hId == null) return;

    final payload = {"type": "host_info", "host_user_id": hId.toString()};
    final bytes = utf8.encode(jsonEncode(payload));

    try {
      await room.localParticipant?.publishData(bytes, reliable: true);
    } catch (_) {}
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

  void showOverlay() => emit(state.copyWith(showCallOverlay: true));

  void hideOverlay() => emit(state.copyWith(showCallOverlay: false));

  @override
  Future<void> close() async {
    await disconnect();
    super.close();
  }
}
