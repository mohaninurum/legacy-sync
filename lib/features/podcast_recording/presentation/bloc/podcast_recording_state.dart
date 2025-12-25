

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
  final bool shuffle;
  final TopicCategory? selectedCategory;

  const PodCastRecordingState({
    required this.status,
    required this.participants,
    required this.inviteUserList,
    required this.allTopics,
    required this.duration,
    required this.currentTopicIndex,
    required this.filteredTopics,
    required this.shuffle,
    required this.selectedCategory,
  });

  factory PodCastRecordingState.initial() {
    return const PodCastRecordingState(
      status: PodCastRecordingStatus.idle,
      participants: [],
      inviteUserList: [],
      allTopics: [],
      filteredTopics: [],
      duration: Duration.zero,
      currentTopicIndex: 0,
      selectedCategory: null,
      shuffle: false,
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
    bool? shuffle,
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
      shuffle: shuffle ?? this.shuffle,
      selectedCategory:
      selectedCategory ?? this.selectedCategory,
    );
  }
}
