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

  const MyPodcastState({
    required this.selectedTab,
    required this.podcasts,
    required this.listPodcastsContinueListening,
    required this.recentUserList,
    required this.loading,
  });

  factory MyPodcastState.initial() {
    return const MyPodcastState(
      selectedTab: 'Posted',
      podcasts: [],
      listPodcastsContinueListening: [],
      recentUserList: [],
      loading: true,
    );
  }

  MyPodcastState copyWith({
    String? selectedTab,
    List<PodcastModel>? podcasts,
    List<PodcastModel>? listPodcastsContinueListening,
    List<RecentUserListModel>? recentUserList,
    bool? loading,
  }) {
    return MyPodcastState(
      selectedTab: selectedTab ?? this.selectedTab,
      podcasts: podcasts ?? this.podcasts,
      listPodcastsContinueListening: listPodcastsContinueListening??this.listPodcastsContinueListening,
      recentUserList: recentUserList??this.recentUserList,
      loading: loading ?? this.loading,
    );
  }
}
