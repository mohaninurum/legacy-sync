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
    loadTab('Posted');
  }

  final MyPoadastUsecase _myPoadastUsecase = MyPoadastUsecase();

  List<PodcastModel> _allPodcasts = [];
  final List<PodcastModel> _allPodcastsContinueListening = [];
  final List<RecentUserListModel> recentUserList = [];



  Future<void> fetchMyPodcastTab(String tab) async {
    Utils.showLoader();
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final mypodcast = await _myPoadastUsecase.getMyPodcast(userId);
    String postType = 'Posted';
    mypodcast.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");

        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        if (result.data != null) {
          print("DATA ON SUCCESS:: ${result.data}");
          _allPodcasts.clear();
          result.data.forEach((element) {
            if (element.isPosted) {
              postType = "Posted";
            } else {
              postType = "Draft";
            }
            _allPodcasts.add(
              PodcastModel(
                podcastId: element.podcastId,
                title: element.title,
                subtitle: element.description ?? '',
                relationship:  element.members.isNotEmpty? element.members[0].firstName:"",
                duration: Utils.secondsToHrOrMin(element.durationSeconds),
                image: element.thumbnail,
                type: postType,
                author: "",
                audioPath: element.audioUrl,
                listenedSec: element.listenedSeconds,
                totalDurationSec: element.durationSeconds,
                description: element.description ?? '',
                summary:
                    "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",
              ),
            );
          });
          emit(state.copyWith(isLoading: false));

        } else {
          emit(
            state.copyWith(isLoading: false, error: "No profile data found"),
          );
        }
      },
    );

    loadTab(tab);
    fetchFavouritePodcastList();
    Utils.closeLoader();
  }

  Future<void> fetchFavouritePodcastList() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final mypodcast = await _myPoadastUsecase.getFavouritePodcastList(userId);
    mypodcast.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");

        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        if (result.data != null) {
          print("DATA ON SUCCESS::Favourite Podcast List ${result.data}");
          result.data.forEach((element) {
            _allPodcasts.add(
              PodcastModel(
                podcastId: element.podcastId,
                title: element.title,
                subtitle: element.podcastTopic ?? '',
                relationship: element.members.isNotEmpty? element.members[0].firstName:"",
                duration: Utils.secondsToHrOrMin(element.durationSeconds),
                image: element.thumbnail,
                type: "Favorite",
                author: "",
                audioPath: element.audioUrl,
                listenedSec: element.durationSeconds,
                totalDurationSec: element.durationSeconds,
                description: element.podcastTopic ?? '',
                summary:
                    "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",
              ),
            );
          });
          emit(state.copyWith(isLoading: false));

        } else {
          emit(
            state.copyWith(isLoading: false, error: "No profile data found"),
          );
        }
      },
    );
  }

  Future<void> loadTab(String tab) async {
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

  void loadPodcast(PodcastModel? podcast) {
    emit(state.copyWith(podcast: podcast));
  }

  Future<void> allPodcastsContinueListening() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final ContinueListening = await _myPoadastUsecase.getContinueListeningList(
      userId,
    );
    String postType = 'Posted';
    ContinueListening.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        Utils.closeLoader();
        print(
          "DATA ON SUCCESS all Podcasts Continue Listening :: ${result.data.length}",
        );
        _allPodcastsContinueListening.clear();
        result.data.forEach((element) {
          _allPodcastsContinueListening.add(
            PodcastModel(
              podcastId: element.podcastId,
              title: element.title,
              subtitle: element.description ?? '',
              relationship: element.members.isNotEmpty? element.members[0].firstName:"",
              duration: Utils.secondsToHrOrMin(element.durationSeconds),
              image: element.thumbnail,
              type: postType,
              author: "",
              audioPath: element.audioUrl,
              listenedSec: element.listenedSeconds,
              totalDurationSec: element.durationSeconds,
              description: element.description ?? '',
              summary:
                  "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",
            ),
          );
        });
        emit(
          state.copyWith(
            listPodcastsContinueListening: _allPodcastsContinueListening,
            isLoading: false,
          ),
        );
      },
    );
  }

  Future<void> fetchRecentUserList() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final result = await _myPoadastUsecase.getRecentFriendList(userId);
    result.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        Utils.closeLoader();
        print("DATA ON SUCCESS recent User List:: ${result.data.length}");
        recentUserList.clear();
        result.data.forEach((element) {
          recentUserList.add(
            RecentUserListModel(
              relationship: element.firstName,
              duration: Utils.formatDuration(
                Duration(
                  seconds: int.parse(element.durationSeconds.toString()),
                ),
              ),
              image: "assets/images/user_image1.png",
              type: CallType.incoming,
              author: "",
              date: element.createdAt,
            ),
          );
          print(element.firstName);
        });
        emit(state.copyWith(recentUserList: recentUserList, isLoading: false));
      },
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
