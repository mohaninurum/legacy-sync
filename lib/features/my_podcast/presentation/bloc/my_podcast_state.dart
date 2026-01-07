import '../../data/podcast_model.dart';
import '../../data/recent_user_list_model.dart';


enum CallType {
  incoming,
  outgoing,
  Missed
}


class MyPodcastState {
  final String selectedTab;
  final String error;
  final List<PodcastModel> podcasts;
  final List<PodcastModel> listPodcastsContinueListening;
  final List<RecentUserListModel> recentUserList;
  final bool isLoading;
  final PodcastModel? podcast;
  const MyPodcastState({
    required this.selectedTab,
    required this.error,
    required this.podcasts,
    required this.listPodcastsContinueListening,
    required this.recentUserList,
    required this.isLoading,
    required this.podcast,
  });

  factory MyPodcastState.initial() {
    return const MyPodcastState(
      selectedTab: 'Posted',
      error: '',
      podcasts: [],
      listPodcastsContinueListening: [],
      recentUserList: [],
      isLoading: true,
      podcast: null,
    );
  }

  MyPodcastState copyWith({
    String? selectedTab,
    String? error,
    List<PodcastModel>? podcasts,
    List<PodcastModel>? listPodcastsContinueListening,
    List<RecentUserListModel>? recentUserList,
    bool? isLoading,
    PodcastModel? podcast,
  }) {
    return MyPodcastState(
      selectedTab: selectedTab ?? this.selectedTab,
      error: error ?? this.error,
      podcasts: podcasts ?? this.podcasts,
      listPodcastsContinueListening: listPodcastsContinueListening??this.listPodcastsContinueListening,
      recentUserList: recentUserList??this.recentUserList,
      isLoading: isLoading ?? this.isLoading,
      podcast:podcast ?? this.podcast,
    );
  }
}
