import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/participant_info.dart';
import 'package:livekit_client/livekit_client.dart';

enum LiveKitRecordingStatus { idle, recording, paused, completed }

enum TopicCategory { family, relationship, Shuffle }

enum CallStatus { idle, calling, connected, disconnected }

enum InviteStatus { idle, sending, success, failure }

enum LiveKitStatus { initial, connecting, connected, failure }

class LiveKitConnectionState extends Equatable {
  final List<ParticipantTrack> participantTracks;

  final InviteStatus inviteStatus;
  final String? inviteMessage;
  final Set<int> invitedFriendIds;
  final LiveKitStatus status;
  final LiveKitRecordingStatus recordingStatus;
  final List<FriendsDataList> participants;
  final List<FriendsDataList> inviteUserList;
  final List<PodcastTopicsModel> allTopics;
  final Duration duration;
  final List<PodcastTopicsModel> filteredTopics;
  final TopicCategory? selectedCategory;
  final CallStatus? callStatus;

  final bool? isSpeaker;
  final bool? isMic;

  final int currentTopicIndex;
  final bool isLoading;
  final String? error;

  final String? message;

  final String? roomId;
  final int? podcastId;

  final Room? room;
  final EventsListener<RoomEvent>? listener;

  //additional

  final bool? showRecordingStatusDialog;
  final bool? activeRecording;
  final String? dataReceivedText;
  final bool? showPlayAudioManuallyDialog;
  final bool needsPublishConfirm;
  final int? invitingFriendId;

  // In state:
  final bool isHost;
  final int? myUserId;
  final String? myUserName;
  final bool consentGiven;


  const LiveKitConnectionState({
    this.myUserId,
    this.myUserName,
    this.participantTracks = const [],
    this.inviteStatus = InviteStatus.idle,
    this.inviteMessage,
    this.invitedFriendIds = const {},

    this.status = LiveKitStatus.initial,
    this.recordingStatus = LiveKitRecordingStatus.idle,
    this.participants = const [],
    this.inviteUserList = const [],
    this.allTopics = const [],
    this.duration = Duration.zero,
    this.filteredTopics = const [],
    this.selectedCategory,
    this.callStatus = CallStatus.idle,
    this.isSpeaker = true,
    this.isMic = true,
    this.currentTopicIndex = 0,
    this.isLoading = false,
    this.error,
    this.message,
    this.roomId,
    this.podcastId,
    this.room,
    this.listener,

    this.showRecordingStatusDialog,
    this.activeRecording,
    this.dataReceivedText,
    this.showPlayAudioManuallyDialog,
    this.needsPublishConfirm = false,
    this.invitingFriendId,

    this.isHost = false,
    this.consentGiven = false,
  });

  LiveKitConnectionState copyWith({
    int? myUserId,
    String? myUserName,
    List<ParticipantTrack>? participantTracks,
    InviteStatus? inviteStatus,
    String? inviteMessage,
    Set<int>? invitedFriendIds,

    LiveKitStatus? status,
    LiveKitRecordingStatus? recordingStatus,
    List<FriendsDataList>? participants,
    List<FriendsDataList>? inviteUserList,
    List<PodcastTopicsModel>? allTopics,
    Duration? duration,
    List<PodcastTopicsModel>? filteredTopics,
    int? currentTopicIndex,
    TopicCategory? selectedCategory,
    CallStatus? callStatus,

    bool? isSpeaker,
    bool? isMic,

    bool? shuffle,
    bool? isLoading,
    String? error,

    String? message,
    String? roomId,
    int? podcastId,
    Room? room,
    EventsListener<RoomEvent>? listener,

    bool? showRecordingStatusDialog,
    bool? activeRecording,
    String? dataReceivedText,
    bool? showPlayAudioManuallyDialog,
    bool? needsPublishConfirm,

    int? invitingFriendId,

    // In state:
    bool? isHost,
    bool? consentGiven,

  }) {
    return LiveKitConnectionState(
      myUserId: myUserId ?? this.myUserId,
      myUserName: myUserName ?? this.myUserName,
      participantTracks: participantTracks ?? this.participantTracks,
      invitingFriendId: invitingFriendId ?? this.invitingFriendId,
      inviteStatus: inviteStatus ?? this.inviteStatus,
      inviteMessage: inviteMessage,
      invitedFriendIds: invitedFriendIds ?? this.invitedFriendIds,

      status: status ?? this.status,
      recordingStatus: recordingStatus ?? this.recordingStatus,
      participants: participants ?? this.participants,
      inviteUserList: inviteUserList ?? this.inviteUserList,
      allTopics: allTopics ?? this.allTopics,
      duration: duration ?? this.duration,
      filteredTopics: filteredTopics ?? this.filteredTopics,
      currentTopicIndex: currentTopicIndex ?? this.currentTopicIndex,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      callStatus: callStatus ?? this.callStatus,
      isSpeaker: isSpeaker ?? this.isSpeaker,
      isMic: isMic ?? this.isMic,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      roomId: roomId ?? this.roomId,
      podcastId: podcastId ?? this.podcastId,
      room: room ?? this.room,
      listener: listener ?? this.listener,

      showRecordingStatusDialog:
          showRecordingStatusDialog ?? this.showRecordingStatusDialog,
      activeRecording: activeRecording ?? this.activeRecording,
      dataReceivedText: dataReceivedText ?? this.dataReceivedText,
      showPlayAudioManuallyDialog:
          showPlayAudioManuallyDialog ?? this.showPlayAudioManuallyDialog,
      needsPublishConfirm: needsPublishConfirm ?? this.needsPublishConfirm,


      isHost: isHost ?? this.isHost,
      consentGiven: consentGiven ?? this.consentGiven,
    );
  }

  @override
  List<Object?> get props => [
    myUserId,
    myUserName,
    invitingFriendId,
    showRecordingStatusDialog,
    activeRecording,
    dataReceivedText,
    showPlayAudioManuallyDialog,
    inviteStatus,
    inviteMessage,
    invitedFriendIds,
    status,
    recordingStatus,
    participants,
    inviteUserList,
    allTopics,
    duration,
    filteredTopics,
    currentTopicIndex,
    selectedCategory,
    callStatus,
    isSpeaker,
    isMic,
    isLoading,
    error,
    message,
    roomId,
    podcastId,
    needsPublishConfirm,

    isHost,
    consentGiven,
  ];
}
