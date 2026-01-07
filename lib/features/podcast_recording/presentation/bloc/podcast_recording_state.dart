

import '../../data/podcast_topic/podcast_topics_model.dart';
import '../../data/user_list_model/user_list_model.dart';

enum PodCastRecordingStatus {
  idle,
  recording,
  paused,
  completed,
}

enum TopicCategory {
  family,
  relationship,
  Shuffle
}
enum CallStatus {
  idle,
  calling,
  connected,
  disconnected,
}

class TopicModel {
  final String title;
  final TopicCategory category;

  TopicModel({
    required this.title,
    required this.category,
  });
}


class PodCastRecordingState {
  final PodCastRecordingStatus status;
  final List<UserListModel> participants;
  final List<UserListModel> inviteUserList;
  final List<PodcastTopicsModel> allTopics;
  final Duration duration;
  final int currentTopicIndex;
  final List<PodcastTopicsModel> filteredTopics;
  final TopicCategory? selectedCategory;
  final CallStatus? callStatus;
  double dbLevel;
  final bool? isSpeaker;
  final bool? isMic;
  final bool isLoading;
  final String? audioPath;
  final String? error;



   PodCastRecordingState({
    required this.status,
    required this.participants,
    required this.inviteUserList,
    required this.allTopics,
    required this.duration,
    required this.currentTopicIndex,
    required this.filteredTopics,
    required this.selectedCategory,
    required this.callStatus,
    required this.dbLevel,
    required this.isSpeaker,
    required this.isMic,
    required this.isLoading,
    required this.audioPath,
    required this.error,


  });

  factory PodCastRecordingState.initial() {
    return  PodCastRecordingState(
      status: PodCastRecordingStatus.idle,
      participants: [],
      inviteUserList: [],
      allTopics: [],
      filteredTopics: [],
      duration: Duration.zero,
      currentTopicIndex: 0,
      selectedCategory: null,
      callStatus: null,
      dbLevel : 0.0,
      isSpeaker: false,
      isMic: false,
        isLoading: true,
        audioPath:"",
        error:""
    );
  }

  PodCastRecordingState copyWith({
    PodCastRecordingStatus? status,
    List<UserListModel>? participants,
    List<UserListModel>? inviteUserList,
    List<PodcastTopicsModel>? allTopics,
    List<PodcastTopicsModel>? filteredTopics,
    Duration? duration,
    int? currentTopicIndex,
    TopicCategory? selectedCategory,
    CallStatus? callStatus,
    bool? shuffle,
    double? dbLevel,
    bool? isSpeaker,
    bool? isMic,
    bool? isLoading,
    String? audioPath,
    String? error,
  }) {
    return PodCastRecordingState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      inviteUserList: inviteUserList ?? this.inviteUserList,
      allTopics: allTopics ?? this.allTopics,
      filteredTopics: filteredTopics ?? this.filteredTopics,
      duration: duration ?? this.duration,
      currentTopicIndex:
      currentTopicIndex ?? this.currentTopicIndex,
      selectedCategory:
      selectedCategory ?? this.selectedCategory,
      callStatus:
      callStatus ?? this.callStatus,
      dbLevel:
      dbLevel ?? this.dbLevel,
      isSpeaker:
      isSpeaker ?? this.isSpeaker,
      isMic:
      isMic ?? this.isMic,
      isLoading:
      isLoading ?? this.isLoading,
      audioPath:
      audioPath ?? this.audioPath,     error:
    error ?? this.error,

    );
  }
}
