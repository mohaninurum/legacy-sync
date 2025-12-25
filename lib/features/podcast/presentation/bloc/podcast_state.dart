

import '../../data/model/build_own_podcast_model.dart';


class PodcastState {
  final isLoading;
  List<BuildOwnPodcastModel> buildOwnPodcastList = [];


   PodcastState({
    required this.isLoading,
    required this.buildOwnPodcastList,

  });

  /// Initial state
  factory PodcastState.initial() {
    return  PodcastState(
      isLoading: false,
      buildOwnPodcastList: [],
    );
  }

  PodcastState copyWith({
    bool? isLoading,
    List<BuildOwnPodcastModel>? buildOwnPodcastList,
  }) {
    return PodcastState(
      isLoading: isLoading ?? this.isLoading,
      buildOwnPodcastList: buildOwnPodcastList ?? this.buildOwnPodcastList,

    );
  }

}
