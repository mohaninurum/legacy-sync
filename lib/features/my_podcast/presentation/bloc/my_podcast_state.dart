import '../../data/podcast_model.dart';
import '../../data/recent_user_list_model.dart';


enum CallType {
  incoming,
  outgoing,
  Missed
}


class MyPodcastState {
  final String selectedTab;
  final List<PodcastModel> podcasts;
  final List<PodcastModel> listPodcastsContinueListening;
  final List<RecentUserListModel> recentUserList;
  final bool loading;
  final PodcastModel? podcast;
  const MyPodcastState({
    required this.selectedTab,
    required this.podcasts,
    required this.listPodcastsContinueListening,
    required this.recentUserList,
    required this.loading,
    required this.podcast,
  });

  factory MyPodcastState.initial() {
    return const MyPodcastState(
      selectedTab: 'Posted',
      podcasts: [],
      listPodcastsContinueListening: [],
      recentUserList: [],
      loading: true,
      podcast: null,
    );
  }

  MyPodcastState copyWith({
    String? selectedTab,
    List<PodcastModel>? podcasts,
    List<PodcastModel>? listPodcastsContinueListening,
    List<RecentUserListModel>? recentUserList,
    bool? loading,
    PodcastModel? podcast,
  }) {
    return MyPodcastState(
      selectedTab: selectedTab ?? this.selectedTab,
      podcasts: podcasts ?? this.podcasts,
      listPodcastsContinueListening: listPodcastsContinueListening??this.listPodcastsContinueListening,
      recentUserList: recentUserList??this.recentUserList,
      loading: loading ?? this.loading,
      podcast:podcast ?? this.podcast,
    );
  }
}
