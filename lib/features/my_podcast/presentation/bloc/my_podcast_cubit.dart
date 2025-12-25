import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/podcast_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_podcast_state.dart';

class MyPodcastCubit extends Cubit<MyPodcastState> {
  MyPodcastCubit() : super(MyPodcastState.initial()) {
    loadTab('Posted');
  }

  final List<PodcastModel> _allPodcasts = [
  PodcastModel(
  title: "The Heart That Raised Me",
  subtitle: "A quiet talk with Mom about love...",
  duration: "30.22",
  image: "assets/images/my_podcast_img1.png",
  type: "Posted",
  ),
  PodcastModel(
  title: "Through His Eyes",
  subtitle: "Listening to Dad’s perspective...",
  duration: "1 hr",
  image: "assets/images/my_podcast_img2.png",
  type: "Draft",
  ),
  PodcastModel(
  title: "Growing Side By Side",
  subtitle: "Talking with my brother...",
  duration: "45 min",
  image: "assets/images/my_podcast_im3.png",
  type: "Favorite",
  ),
  ];

  void loadTab(String tab) {
    emit(
      state.copyWith(
        selectedTab: tab,
        podcasts: _allPodcasts.where((e) => e.type == tab).toList(),
        loading: false,
      ),
    );
  }
}

