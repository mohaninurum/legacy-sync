import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/podcast_model.dart';



import '../../data/recent_user_list_model.dart';
import 'my_podcast_state.dart';

class MyPodcastCubit extends Cubit<MyPodcastState> {
  MyPodcastCubit() : super(MyPodcastState.initial()) {
    loadTab('Posted');
  }

  final List<PodcastModel> _allPodcasts = [
    PodcastModel(
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/my_podcast_img1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/my_podcast_img2.png",
      type: "Posted",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Growing Side By Side",
      subtitle: "Talking with my brother...",
      relationship: "mom",
      duration: "45 min",
      image: "assets/images/my_podcast_im3.png",
      type: "Posted",
      author: "",
      listenedSec: 300,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/my_podcast_img1.png",
      type: "Draft",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/my_podcast_img2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/my_podcast_img1.png",
      type: "Favorite",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/my_podcast_img2.png",
      type: "Favorite",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Growing Side By Side",
      subtitle: "Talking with my brother...",
      relationship: "mom",
      duration: "45 min",
      image: "assets/images/my_podcast_im3.png",
      type: "Favorite",
      author: "",
      listenedSec: 300,
      totalDurationSec: 1800,
    ),
  ];

  final List<PodcastModel> _allPodcastsContinueListening = [
    PodcastModel(
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/continue_listening1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/continue_listning2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
    ),
    PodcastModel(
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/continue_listening1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
    ),
  ];



  final List<RecentUserListModel> recentUserList = [
    RecentUserListModel(
      relationship: "Mom",
      duration: "",
      image: "assets/images/user_image1.png",
      type: CallType.Missed,
      author: "",
      date: "2025-12-24 18:45:00"
    ),
    RecentUserListModel(
      relationship: "Mom",
      duration: "30:00",
      image: "assets/images/user_image1.png",
      type: CallType.incoming,
      author: "",
        date: "2025-12-24 18:45:00"
    ),
    RecentUserListModel(
      relationship: "me",
      duration: "15.00",
      image: "assets/images/user_image2.png",
      type: CallType.incoming,
      author: "",
        date: "2025-12-24 18:45:00"
    ),
  ];

  void loadTab(String tab) {
    if (tab == "all") {
      print("all");
      emit(state.copyWith(podcasts: _allPodcasts, loading: false));
    } else {
      emit(
        state.copyWith(
          selectedTab: tab,
          podcasts: _allPodcasts.where((e) => e.type == tab).toList(),
          loading: false,
        ),
      );
    }
  }

  void allPodcastsContinueListening() {
    emit(
      state.copyWith(
        listPodcastsContinueListening: _allPodcastsContinueListening,
        loading: false,
      ),
    );
  }
  void fetchRecentUserList() {
    emit(
      state.copyWith(
        recentUserList: recentUserList,
        loading: false,
      ),
    );
  }

  double listeningProgress(int listened, int total) {
    if (total == 0) return 0;
    return listened / total;
  }

  String timeLeftText(int listened, int total) {
    final leftSec = total - listened;
    final minutes = (leftSec / 60).ceil();
    return "$minutes min left";
  }
}
