import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/components/comman_components/add_to_wishlist_dialog.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/domain/usecases/get_favorite_memories_usecase.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_state/favorite_memories_state.dart';
import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';
import 'package:legacy_sync/features/my_podcast/domain/usecases/myPoadcast_usecase.dart';

class FavoriteMemoriesCubit extends Cubit<FavoriteMemoriesState> {
  FavoriteMemoriesCubit() : super(FavoriteMemoriesState.initial());

  final favMemoriesUseCases = GetFavoriteMemoriesUsecase();
  final MyPoadastUsecase _myPoadastUsecase = MyPoadastUsecase();

  List<PodcastModel> _allPodcasts = [];


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

  Future<void> fetchMyPodcastTab(String tab) async {
    Utils.showLoader();
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final mypodcast = await _myPoadastUsecase.getMyPodcast(userId);
    String postType = 'Posted';
    mypodcast.fold(
          (error) {
        print("APP EXCEPTION:: ${error.message}");

        emit(state.copyWith(isLoading: false, errorMessage: error.message));
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
            state.copyWith(isLoading: false, errorMessage: "No profile data found"),
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

        emit(state.copyWith(isLoading: false, errorMessage: error.message));
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
            state.copyWith(isLoading: false, errorMessage: "No profile data found"),
          );
        }
      },
    );
  }

  Future<void> loadQuestion({required int userID}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try{
      final result = await favMemoriesUseCases.getListOfFavQuestion(userID: userID);
      result.fold((failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message.toString()));
      } , (data) {
        List<FavoriteModelData> finalList = [];
        Map<String, List<FavoriteModelData>> grouped = {};
        for (var question in data.data ?? []) {
          grouped.putIfAbsent(question.moduleTitle ?? "Unknown Module", () => []);
          grouped[question.moduleTitle]!.add(question);
        }
        grouped.forEach((moduleTitle, questions) {
          finalList.add(FavoriteModelData(
            moduleTitle: moduleTitle,
            isHeader: true,
          ));
          finalList.addAll(questions);
        });

        emit(state.copyWith(isLoading: false, favoriteQuestions:finalList));
      },);
    }catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void addFavQuestion({required questionId , required BuildContext context}) async {
    try{
      Utils.showLoader(message: "Adding as a favorite question...");
      final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      print("UserId ::: ${userID}");
      print("questionId ::: ${questionId}");

      final body = {
        "user_id":userID,
        "question_id":questionId
      };
      final memoriesData = await favMemoriesUseCases.addFavQuestion(body: body);
      Utils.closeLoader();
      memoriesData.fold((failure){emit(state.copyWith(errorMessage: failure.message.toString()));
       Utils.showInfoDialog(context: context, content: failure.message.toString(),title: "Information");

      }, (data) {
        AddToWishlistDialog.show(context);
      });
    } catch (e){
      Utils.closeLoader();
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void expandCard({required int index}) {
    final questions = List<FavoriteModelData>.from(state.favoriteQuestions);
    questions[index] = questions[index].copyWith(isExpanded: !questions[index].isExpanded!);
    emit(state.copyWith(favoriteQuestions: questions));
  }
}