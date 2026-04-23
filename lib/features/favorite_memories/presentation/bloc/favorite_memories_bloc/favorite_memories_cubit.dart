import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/components/comman_components/add_to_wishlist_dialog.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/domain/usecases/get_favorite_memories_usecase.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_state/favorite_memories_state.dart';
import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';

class FavoriteMemoriesCubit extends Cubit<FavoriteMemoriesState> {
  FavoriteMemoriesCubit() : super(FavoriteMemoriesState.initial());

  final favMemoriesUseCases = GetFavoriteMemoriesUsecase();

  Future<void> loadTab(String tab) async {
    emit(state.copyWith(selectedTab: tab));
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

  void addFavQuestion({required int? questionId , required BuildContext context}) async {
    try{
      Utils.showLoader(message: "Adding as a favorite question...");
      final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

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

  void removeFavQuestion({required int? questionId, required BuildContext context}) async {
    try {
      Utils.showLoader(message: "Removing from favorite questions...");
      final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      final body = {
        "user_id": userID,
        "question_id": questionId
      };
      final result = await favMemoriesUseCases.removeFavQuestion(body: body);
      Utils.closeLoader();
      result.fold(
        (failure) {
          emit(state.copyWith(errorMessage: failure.message.toString()));
          Utils.showInfoDialog(context: context, content: failure.message.toString(), title: "Information");
        },
        (data) {
          Utils.showInfoDialog(context: context, content: "Question removed from favorites successfully", title: "Success");
        },
      );
    } catch (e) {
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