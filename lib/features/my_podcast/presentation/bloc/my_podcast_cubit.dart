import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';
import '../../../../config/db/shared_preferences.dart';
import '../../../../core/utils/utils.dart';
import '../../data/podcast_model.dart';
import '../../data/recent_user_list_model.dart';
import '../../domain/usecases/myPoadcast_usecase.dart';
import 'my_podcast_state.dart';

class MyPodcastCubit extends Cubit<MyPodcastState> {
  MyPodcastCubit() : super(MyPodcastState.initial()) {
    loadTab('Posted');
  }

  final MyPoadastUsecase _myPodCastUseCase = MyPoadastUsecase();

  final List<PodcastModel> _allPodcasts = [];
  final List<PodcastModel> _allPodcastsContinueListening = [];
  final List<RecentUserListModel> recentUserList = [];

  String _sanitize(String input) {
    final s = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return s.isEmpty ? 'user' : s;
  }

  List<PodcastModel> get draftPodcasts =>
      _allPodcasts.where((e) => e.type == "Draft").toList();

  Set<String> get draftTitles =>
      draftPodcasts.map((e) => (e.title ?? '').trim()).where((s) => s.isNotEmpty).toSet();

  Set<String> get draftDescriptions =>
      draftPodcasts.map((e) => (e.description ?? '').trim()).where((s) => s.isNotEmpty).toSet();

  Future<String> _generateShortRoomId() async {
    final prefs = AppPreference();
    final raw = await prefs.get(key: AppPreference.KEY_USER_FIRST_NAME);
    final namePart = _sanitize((raw ?? '').trim());

    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final randomPart =
        List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();

    return '${namePart}_$randomPart';
  }

  Future<void> createRoomAndId() async {
    try {
      final hasInternet = await AppService.hasInternet();
      debugPrint("Internet Status :: $hasInternet");
      if (!await AppService.hasInternet()) {
        emit(
          state.copyWith(
            createRoomStatus: CreateRoomStatus.initial,
            error: "No internet connection. Please try again.",
          ),
        );
        return;
      }
      emit(
        state.copyWith(createRoomStatus: CreateRoomStatus.loading, error: ''),
      );
      final userId = await AppPreference().getInt(
        key: AppPreference.KEY_USER_ID,
      );
      final firstName = await AppPreference().get(
        key: AppPreference.KEY_USER_FIRST_NAME,
      );
      final lastName = await AppPreference().get(
        key: AppPreference.KEY_USER_LAST_NAME,
      );
      final userName = "${firstName}_$lastName";

      print("FirstName New Podcast Cubit :: $firstName");
      print("LastName New Podcast Cubit :: $lastName");
      print("UserName New Podcast Cubit :: $userName");

      if (userId == null) {
        emit(
          state.copyWith(
            createRoomStatus: CreateRoomStatus.failure,
            error: "Login session expired, try to login again!",
          ),
        );
        return;
      }

      // Keep if you need it later, otherwise remove.
      final roomId = await _generateShortRoomId();

      debugPrint("ROOM ID CREATED SUCCESSFULLY :::: $roomId");

      emit(
        state.copyWith(
          createRoomStatus: CreateRoomStatus.success,
          roomId: roomId,
          userId: userId,
          userName: userName,
          error: '',
        ),
      );
    } catch (e) {
      debugPrint("Error in creating room id :: ${e.toString()}");
    }
  }

  Future<void> fetchMyPodcastTab(String tab) async {
    Utils.showLoader();
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final myPodCast = await _myPodCastUseCase.getMyPodcast(userId);
    myPodCast.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        if (result.data != null) {
          print("DATA ON SUCCESS:: ${result.data}");
          _allPodcasts.clear();
          result.data.forEach((element) {
            final postType = element.isPosted == 1 ? "Posted" : "Draft";
            _allPodcasts.add(
              PodcastModel(
                podcastId: element.podcastId,
                title: (element.title == null || element.title!.trim().isEmpty)
                    ? 'Untitled'
                    : element.title!.trim(),
                relationship: element.members.isNotEmpty
                        ? element.members[0].firstName
                        : "",
                duration: Utils.secondsToHrOrMin(element.durationSeconds ?? 0),
                image: element.thumbnail,
                type: postType,
                author: "",
                audioPath: element.audioUrl,
                listenedSec: element.listenedSeconds,
                totalDurationSec: element.durationSeconds ?? 0,
                description: element.description ?? '',
                isFavourite: element.isFavourite,
                topicType: element.topicType,
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

    await loadTab(tab);
    await fetchFavouritePodcastList();
    Utils.closeLoader();
  }

  Future<void> fetchFavouritePodcastList() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final myPodCast = await _myPodCastUseCase.getFavouritePodcastList(userId);

    myPodCast.fold(
      (error) {
        debugPrint("APP EXCEPTION:: ${error.message}");
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) async {
        if (result.data != null) {
          debugPrint("DATA ON SUCCESS::Favourite Podcast List ${result.data}");
          _allPodcasts.removeWhere((p) => p.isFavourite == 1);
          // result.data.forEach((element) {
          //   final postType = element.isPosted == 1 ? "Posted" : "Draft";
          //
          //   _allPodcasts.add(
          //     PodcastModel(
          //       podcastId: element.podcastId,
          //       title: element.title ?? "Untitled",
          //       relationship: element.members.isNotEmpty
          //               ? element.members[0].firstName
          //               : "",
          //       duration: Utils.secondsToHrOrMin(element.durationSeconds ?? 0),
          //       image: element.thumbnailUrl,
          //       type: postType,
          //       author: "",
          //       audioPath: element.audioUrl,
          //       listenedSec: element.listenedSeconds,
          //       totalDurationSec: element.durationSeconds ?? 0,
          //       description: element.description ?? '',
          //       isFavourite: 1,
          //       // subtitle: element.podcastTopic ?? '',
          //       // summary:
          //       //     "Lorem ipsum dolor sit amet consectetur. Ullamcorper ac nunc justo neque sit mi quis congue hendrerit. Vulputate malesuada blandit integer enim. Magna duis neque sollicitudin feugiat aliquam diam at feugiat lacus. Integer nullam sociis eget mauris sed sodales at. ",
          //     ),
          //   );
          // });
          // loadTab(state.selectedTab);
          for (final element in result.data) {
            final postType = element.isPosted == 1 ? "Posted" : "Draft";

            _allPodcasts.add(
              PodcastModel(
                podcastId: element.podcastId,
                title: element.title ?? "Untitled",
                relationship: element.members.isNotEmpty ? element.members[0].firstName : "",
                duration: Utils.secondsToHrOrMin(element.durationSeconds ?? 0),
                image: element.thumbnailUrl,
                type: postType, // keep as Posted/Draft (fine)
                author: "",
                audioPath: element.audioUrl,
                listenedSec: element.listenedSeconds,
                totalDurationSec: element.durationSeconds ?? 0,
                description: element.description ?? '',
                isFavourite: 1,
                topicType: element.topicType,
              ),
            );
          }

          await loadTab(state.selectedTab);
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
      debugPrint("all");
      emit(state.copyWith(podcasts: _allPodcasts, isLoading: false));
    } else {
      if(tab == "Favourite") {
        emit(
          state.copyWith(
            selectedTab: tab,
            podcasts: _allPodcasts.where((e) => e.isFavourite == 1).toList(),
            isLoading: false,
          ),
        );
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
  }

  void loadPodcast(PodcastModel? podcast) {
    emit(state.copyWith(podcast: podcast));
  }

  Future<void> allPodcastsContinueListening() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final continueListening = await _myPodCastUseCase.getContinueListeningList(
      userId,
    );
    String postType = 'Posted';
    continueListening.fold(
      (error) {
        debugPrint("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        Utils.closeLoader();
        debugPrint(
          "DATA ON SUCCESS all Podcasts Continue Listening :: ${result.data.length}",
        );
        _allPodcastsContinueListening.clear();
        result.data.forEach((element) {
          _allPodcastsContinueListening.add(
            PodcastModel(
              podcastId: element.podcastId,
              title: element.title,
              relationship:
                  element.members.isNotEmpty
                      ? element.members[0].firstName
                      : "",
              duration: Utils.secondsToHrOrMin(element.durationSeconds),
              image: element.thumbnail,
              type: postType,
              author: "",
              audioPath: element.audioUrl,
              listenedSec: element.listenedSeconds,
              totalDurationSec: element.durationSeconds,
              description: element.description ?? '',
              isFavourite: element.isFavourite,
              topicType: element.topicType,
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
    final res = await _myPodCastUseCase.getRecentFriendList(userId);

    res.fold(
          (error) {
        debugPrint("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
          (result) {
        Utils.closeLoader();

        recentUserList.clear();

        for (final element in result.data) {
          // created_at => "2026-02-02 09:06:20"
          final DateTime dt = element.createdAt;

          // call_type => "incoming" / "outgoing"
          final callTypeStr = (element.callType).toLowerCase().trim();
          final callType = callTypeStr == "incoming"
              ? CallType.incoming
              : CallType.outgoing;

          final missed = element.missedCall == 1;

          recentUserList.add(
            RecentUserListModel(
              podcastUserPK: element.podcastUserPK,
              friendId: element.friendId,
              livekitRoomId: element.livekitRoomId,
              firstName: element.firstName,
              lastName: element.lastName,

              // keep raw date if you want
              date: _toApiDate(dt),

              // add these 2
              dateTime: dt,
              type: callType,
              missed: missed,

              // for now placeholder
              image: "assets/images/user_image1.png",

              // optional: keep duration for showing 30:00 etc
              durationSeconds: element.durationSeconds,
            ),
          );
        }

        emit(state.copyWith(recentUserList: List<RecentUserListModel>.from(recentUserList), isLoading: false));
      },
    );
  }

  String _toApiDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }


  // Future<void> fetchRecentUserList() async {
  //   final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
  //   emit(state.copyWith(isLoading: true));
  //   final result = await _myPodCastUseCase.getRecentFriendList(userId);
  //   result.fold(
  //     (error) {
  //       debugPrint("APP EXCEPTION:: ${error.message}");
  //       Utils.closeLoader();
  //       emit(state.copyWith(isLoading: false, error: error.message));
  //     },
  //     (result) {
  //       Utils.closeLoader();
  //       debugPrint("DATA ON SUCCESS recent User List:: ${result.data.length}");
  //       recentUserList.clear();
  //       result.data.forEach((element) {
  //         recentUserList.add(
  //           RecentUserListModel(
  //             image: "assets/images/user_image1.png",
  //             type: CallType.incoming,
  //             firstName: element.firstName,
  //             friendId: element.friendId,
  //             lastName: element.lastName,
  //             livekitRoomId: element.livekitRoomId,
  //             missed: element.missedCall == 1,
  //             podcastUserPK: element.podcastUserPK,
  //             date: Utils.formatDuration(Duration(
  //               seconds: element.createdAt
  //             )),
  //           ),
  //         );
  //         print(element.firstName);
  //       });
  //       emit(state.copyWith(recentUserList: recentUserList, isLoading: false));
  //     },
  //   );
  // }

  DateTime _parseApiDateTime(String s) {
    // expects: "yyyy-MM-dd HH:mm:ss"
    try {
      final parts = s.split(' ');
      final d = parts[0].split('-').map(int.parse).toList();
      final t = parts[1].split(':').map(int.parse).toList();
      return DateTime(d[0], d[1], d[2], t[0], t[1], t[2]);
    } catch (_) {
      return DateTime.now();
    }
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
