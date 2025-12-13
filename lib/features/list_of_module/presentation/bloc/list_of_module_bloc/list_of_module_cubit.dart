import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';
import 'package:legacy_sync/features/list_of_module/domain/usecases/get_list_of_module_usecase.dart';
import 'package:legacy_sync/features/list_of_module/presentation/bloc/list_of_module_state/list_of_module_state.dart';
import 'package:tip_dialog/tip_dialog.dart';
import '../../../data/model/module_answer_model.dart';

class ListOfModuleCubit extends Cubit<ListOfModuleState> {
  ListOfModuleCubit() : super(ListOfModuleState.initial());
  final FlutterTts flutterTts = FlutterTts();
  final usecase = GetListOfModuleUsecase();
  final appPreference = AppPreference();

  @override
  Future<void> close() async {
    await flutterTts.stop();
    return super.close();
  }

  Future<void> loadQuestion({required BuildContext context, required int moduleId, required int friendId, required bool fromFriends, required bool preExpanded}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final effectiveUserId = fromFriends ? friendId : userID;

    try {
      // Check if cached data exists and is valid
      final cachedData = await appPreference.getCachedQuestionData(moduleId: moduleId, userId: effectiveUserId);
     var isSubmitted=  await AppPreference().get(key: "SUBMITTED");
      if (cachedData != null && isSubmitted=="false") {
        // Use cached data
        print("Loading question data from cache for module: $moduleId, user: $effectiveUserId");
        final questionData = QuestionData.fromJson(cachedData);

        print("questionData:: ${jsonEncode(questionData)}");
        _processQuestionData(questionData, preExpanded, context);
        return;
      }

      // No valid cache, fetch from API
      print("Loading question data from API for module: $moduleId, user: $effectiveUserId");
      final moduleData = await usecase.getListOfModules(moduleID: moduleId, userID: effectiveUserId);

      moduleData.fold(
        (failure) {
          emit(state.copyWith(isLoading: false, errorMessage: failure.message.toString(),isDataSave: true));
        },
        (data) async {
          if (data.data != null) {
            // Cache the API response
            await appPreference.cacheQuestionData(moduleId: moduleId, userId: effectiveUserId, questionData: data.data!.toJson());
            // Process the data
            _processQuestionData(data.data!, preExpanded, context);
          } else {
            emit(state.copyWith(isLoading: false, errorMessage: "No data received",isDataSave: true));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString(),isDataSave: true));
    }
  }

  /// Process question data (common logic for both cached and API data)
  void _processQuestionData(QuestionData questionData, bool preExpanded, BuildContext context) async {
    var total = 0;
    QuestionItems currentQuestionItems = QuestionItems();
    if (questionData.questions != null && questionData.questions!.isNotEmpty) {
      for (int i = 0; i < questionData.questions!.length; i++) {
        if (questionData.questions![i].islocked == false) {
          currentQuestionItems = questionData.questions![i];
          total++;
        }
      }
      emit(state.copyWith(isLoading: false, data: questionData, errorMessage: null, totalAnswered: total, currentQuestionItems: currentQuestionItems));
    }

    if (preExpanded) {
      if (questionData.questions != null) {
        int lastEnabledIndex = -1;
        QuestionItems? items;
        print("lastEnabledIndex: 11 : $lastEnabledIndex");
        // Find the last enabled card
        for (int i = 0; i < questionData.questions!.length; i++) {
          final mData = questionData.questions![i];
          if (mData.islocked! == false) {
            print("lastEnabledIndex: 22 : $lastEnabledIndex");
            lastEnabledIndex = i;
            items = mData;
          }
        }
        // If we found at least one enabled card, use it for navigation
        if (lastEnabledIndex != -1 && items != null) {
          expandCard(index: lastEnabledIndex);
          getExpandedCardData(questionId: items.questionidpK!, index: lastEnabledIndex);
          final result = await Navigator.pushNamed(context, RoutesName.ANSWER_SCREEN, arguments: {"qId": items.questionidpK, "mIndex": lastEnabledIndex, "questionText": items.questiondescription});
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insight added successfully")));
          }
        }
        print("lastEnabledIndex: 33 : $lastEnabledIndex");
      }
    }
  }

  Future<void> startSpeaking(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      // Set up completion listener
      flutterTts.setCompletionHandler(() {
        emit(state.copyWith(isSpeaking: false));
      });

      // Set up error listener
      flutterTts.setErrorHandler((msg) {
        emit(state.copyWith(isSpeaking: false));
      });

      // Set up cancel listener
      flutterTts.setCancelHandler(() {
        emit(state.copyWith(isSpeaking: false));
      });

      await flutterTts.speak(text);
      emit(state.copyWith(isSpeaking: true));
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await flutterTts.stop();
      emit(state.copyWith(isSpeaking: false));
    } catch (e) {
      print("TTS Stop Error: $e");
    }
  }

  void expandCard({required int index}) {
    final questions = List<QuestionItems>.from(state.data.questions!);
    questions[index] = questions[index].copyWith(isExpanded: !questions[index].isExpanded);
    emit(state.copyWith(data: state.data.copyWith(questions: questions)));
  }

  void getExpandedCardData({required int questionId, required int index}) async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    try {
      final body = {"question_id": questionId, "user_id": userId};
      final moduleData = await usecase.getAnswerOfModule(body: body);
      moduleData.fold(
        (failure) {
          print("Error1 ${failure.message}");
        },
        (data) async {
          int totalAnswered = state.totalAnswered;
          if (data.data != null && data.data!.isNotEmpty) {
            QuestionData currentData = state.data;
            if (currentData.questions!.length - 1 != index) {
              if (currentData.questions![index + 1].islocked == true) {
                QuestionItems currentQuestionItems = QuestionItems();
                currentData.questions![index + 1] = currentData.questions![index + 1].copyWith(islocked: false);
                totalAnswered++;
                currentQuestionItems = currentData.questions![index + 1];
                emit(state.copyWith(currentQuestionItems: currentQuestionItems));
              }
            } else {
              print("MULTI_GENDER:: $index");
            }
            currentData.questions![index] = currentData.questions![index].copyWith(answers: data.data);
            emit(state.copyWith(data: currentData, totalAnswered: totalAnswered));

            // Update cache with new answer data
            await _updateCacheWithCurrentData();
          }
        },
      );
    } catch (e) {
      print("Error2 ${e.toString()}");
    }
  }

  void deleteAnswerOfModule({required answerId, required int parentIndex, required int index}) async {
    try {
      Utils.showLoader(message: "Deleting answer...");
      final moduleData = await usecase.deleteAnswerOfModule(answerId: answerId);
      Utils.closeLoader();
      moduleData.fold((failure) {}, (data) async {
        if (data.status == "success") {
          QuestionData currentData = state.data;
          List<ModuleAnswerData> currentAnswers = List<ModuleAnswerData>.from(currentData.questions![parentIndex].answers!);
          currentAnswers.removeAt(index);
          currentData.questions![parentIndex] = currentData.questions![parentIndex].copyWith(answers: currentAnswers);
          emit(state.copyWith(data: currentData));
          print("Delete Answer Data: ${state.data.questions![parentIndex].answers?.length}");

          // Update cache after deletion
          await _updateCacheWithCurrentData();
        }
      });
    } catch (e) {
      Utils.closeLoader();
    }
  }

  /// Update cache with current state data
  Future<void> _updateCacheWithCurrentData() async {
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      // We need to determine the moduleId from the current data
      // Since we don't store moduleId in state, we'll extract it from the questions
      if (state.data.questions != null && state.data.questions!.isNotEmpty) {
        final moduleId = state.data.questions!.first.legacymoduleidfK;
        if (moduleId != null) {
          // await appPreference.cacheQuestionData(moduleId: moduleId, userId: userId, questionData: state.data.toJson());
          print("Cache updated after data modification");
        }
      }
    } catch (e) {
      print("Error updating cache: $e");
    }
  }

  /// Clear cache for current module (useful for force refresh)
  Future<void> clearCurrentModuleCache({required int moduleId}) async {
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      final appPreference = AppPreference();

      await appPreference.clearCachedQuestionData(moduleId: moduleId, userId: userId);
      print("Cache cleared for module: $moduleId");
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }

  void submitFinalAnswer(int qId, BuildContext context, int mIndex, File file) async {
    try {
      TipDialogHelper.loading("Submitting..");

      // Check if file exists for audio/video answers
      if (!file.existsSync()) {
        TipDialogHelper.dismiss();
        print("Error: Recorded file does not exist at path: ${file.path}");
        return;
      }

      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      // For text-only answers, create a dummy file since the API signature requires it
      // but the repository implementation will handle text-only submissions differently
      final result = await usecase.submitAnswer(qId: qId, userId: userId, answerType: 4, answerText: "", file: file);
      TipDialogHelper.dismiss();
      result.fold(
        (l) {
          TipDialogHelper.dismiss();
          Utils.showInfoDialog(context: context, title: "Submission Failed", content: l.message ?? "Failed to submit answer. Please try again.");
        },
        (r) async {
          getExpandedCardData(questionId: qId, index: mIndex);
          TipDialogHelper.success("Submitted");
          await Future.delayed(const Duration(milliseconds: 1200));
          TipDialogHelper.dismiss();
         AppPreference().set(key: "SUBMITTED", value: "true");
        },
      );
    } catch (e) {
      TipDialogHelper.dismiss();
      print("Error submission: $e");
    }
  }


  void isQuestionContinue(bool moduleValue,) async {
      emit(state.copyWith(isQuestionContinue: moduleValue));
  }



}
