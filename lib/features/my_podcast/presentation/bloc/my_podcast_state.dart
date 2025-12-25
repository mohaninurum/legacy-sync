import '../../data/podcast_model.dart';


class MyPodcastState {
  final String selectedTab;
  final List<PodcastModel> podcasts;
  final bool loading;

  const MyPodcastState({
    required this.selectedTab,
    required this.podcasts,
    required this.loading,
  });

  factory MyPodcastState.initial() {
    return const MyPodcastState(
      selectedTab: 'Posted',
      podcasts: [],
      loading: true,
    );
  }

  MyPodcastState copyWith({
    String? selectedTab,
    List<PodcastModel>? podcasts,
    bool? loading,
  }) {
    return MyPodcastState(
      selectedTab: selectedTab ?? this.selectedTab,
      podcasts: podcasts ?? this.podcasts,
      loading: loading ?? this.loading,
    );
  }
}
