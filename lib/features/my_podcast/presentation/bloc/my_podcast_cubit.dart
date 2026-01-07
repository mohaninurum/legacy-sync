import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/db/shared_preferences.dart';
import '../../../../config/network/network_api_service.dart';
import '../../../../core/utils/utils.dart';
import '../../data/podcast_model.dart';



import '../../data/recent_user_list_model.dart';
import '../../domain/usecases/myPoadcast_usecase.dart';
import 'my_podcast_state.dart';

class MyPodcastCubit extends Cubit<MyPodcastState> {
  MyPodcastCubit() : super(MyPodcastState.initial()) {
    loadTab('Posted',);
  }

  final MyPoadastUsecase _myPoadastUsecase = MyPoadastUsecase();


  List<PodcastModel> _allPodcasts = [
    PodcastModel(
      podcastId: 1,
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/my_podcast_img1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
      description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",
      summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",

    ),
    PodcastModel(
        podcastId: 1,
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/my_podcast_img2.png",
      type: "Posted",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Growing Side By Side",
      subtitle: "Talking with my brother...",
      relationship: "mom",
      duration: "45 min",
      image: "assets/images/my_podcast_im3.png",
      type: "Posted",
      author: "",
      listenedSec: 300,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Untitled",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "Nov 3, 2025",
      image: "assets/images/my_podcast_img1.png",
      type: "Draft",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
      ,  summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Untitled",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "Nov 3, 2025",
      image: "assets/images/my_podcast_img2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
        ,summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Conversat Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "",
      duration: "Nov 3, 2025",
      image: "assets/images/my_podcast_img2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Untitled",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "Nov 3, 2025",
      image: "assets/images/my_podcast_img2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
      ,  summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/my_podcast_img1.png",
      type: "Favorite",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/my_podcast_img2.png",
      type: "Favorite",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
        ,summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Growing Side By Side",
      subtitle: "Talking with my brother...",
      relationship: "mom",
      duration: "45 min",
      image: "assets/images/my_podcast_im3.png",
      type: "Favorite",
      author: "",
      listenedSec: 300,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
  ];

  final List<PodcastModel> _allPodcastsContinueListening = [
    PodcastModel(     podcastId: 1,
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/continue_listening1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "Through His Eyes",
      subtitle: "Listening to Dad’s perspective...",
      relationship: "dad",
      duration: "1 hr",
      image: "assets/images/continue_listning2.png",
      type: "Draft",
      author: "",
      listenedSec: 200,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
       , summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

    ),
    PodcastModel(     podcastId: 1,
      title: "The Heart That Raised Me",
      subtitle: "A quiet talk with Mom about love...",
      relationship: "mom",
      duration: "30.22",
      image: "assets/images/continue_listening1.png",
      type: "Posted",
      author: "",
      listenedSec: 900,
      totalDurationSec: 1800,
        description: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "
     ,   summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

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


  Future<void> fetchMyPodcastTab(String tab,) async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final mypodcast =  await _myPoadastUsecase.getMyPodcast(userId);
    String postType='Posted';
    mypodcast.fold(
          (error) {
        print("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
          (result) {
        Utils.closeLoader();
        if (result.data != null) {
          print("DATA ON SUCCESS:: ${result.data}");
          _allPodcasts.clear();
          _allPodcastsContinueListening.clear();
          result.data.forEach((element) {
            if(element.isPosted){
              postType="Posted";
            }else{
              postType="Draft";
            }
            if(element.listened_seconds!=0){
              _allPodcastsContinueListening.add(
                PodcastModel(
                    podcastId: element.podcastId,
                    title: element.title,
                    subtitle: element.description??'',
                    relationship: "mom",
                    duration: Utils.secondsToHrOrMin(element.durationSeconds),
                    image: element.thumbnail,
                    type: postType,
                    author: "",
                    listenedSec: element.listened_seconds,
                    totalDurationSec: element.durationSeconds,
                    description: element.description??'',
                    summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

                ),
              );
            }
            _allPodcasts.add(
              PodcastModel(
                 podcastId: element.podcastId,
                  title: element.title,
                  subtitle: element.description??'',
                  relationship: "mom",
                  duration: Utils.secondsToHrOrMin(element.durationSeconds),
                  image: element.thumbnail,
                  type: postType,
                  author: "",
                  listenedSec: element.listened_seconds,
                  totalDurationSec: element.durationSeconds,
                  description: element.description??'',
                  summary: "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. "

              ),
            );
          },);
          emit(state.copyWith(isLoading: false,));

        } else {
          emit(state.copyWith(isLoading: false, error: "No profile data found"));
        }
      },
    );
    loadTab(tab);
    allPodcastsContinueListening();
  }



  Future<void> loadTab(String tab,) async {
    if (tab == "all") {
      print("all");
      emit(state.copyWith(podcasts: _allPodcasts, isLoading: false));
    } else {
      emit(
        state.copyWith(
          selectedTab: tab,
          podcasts: _allPodcasts.where((e) => e.type == tab).toList(),
          isLoading: false,
        ),
      );
    }
  }

  void loadPodcast(PodcastModel? podcast){
    emit(state.copyWith(podcast: podcast));
  }

  void allPodcastsContinueListening() {
    emit(
      state.copyWith(
        listPodcastsContinueListening: _allPodcastsContinueListening,
        isLoading: false,
      ),
    );
  }
  void fetchRecentUserList() {
    emit(
      state.copyWith(
        recentUserList: recentUserList,
        isLoading: false,
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
