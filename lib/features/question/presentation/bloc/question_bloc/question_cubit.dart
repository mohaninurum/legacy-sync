import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:legacy_sync/config/routes/routes_name.dart' show RoutesName;
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';
import 'package:legacy_sync/features/question/data/model/survey_submission.dart';
import 'package:legacy_sync/features/question/domain/usecases/survey_question_case.dart';
import 'package:legacy_sync/features/question/presentation/bloc/question_state/question_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

import '../../../../../config/db/shared_preferences.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionState());
  final FlutterTts flutterTts = FlutterTts();
  final GetQuestionCase questionCase = GetQuestionCase();

  @override
  Future<void> close() async {
    await flutterTts.stop();
    return super.close();
  }

  void getQuestionData() async {
    final name = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    final isSocial = await AppPreference().getInt(key: AppPreference.KEY_LOGIN_TYPE_IS_SOCIAL);
    // final socialLoginProvider = await AppPreference().getInt(key: AppPreference.KEY_SOCIAL_LOGIN_PROVIDER);

    if (isSocial == 1) {
      if (name.isEmpty) {
        emit(state.copyWith(nameIsAvailable: false));
      }else{
        emit(state.copyWith(nameIsAvailable: true));
      }
    }else{
      emit(state.copyWith(nameIsAvailable: true));

    }
    Utils.showLoader();
    try {
      final user = await questionCase.getQuestions();
      Utils.closeLoader();
      await user
          .fold(
            (failure) async {
              Utils.closeLoader();
              // Use fallback data when server fetch fails
              final initialData = QueationModel.getInitialData();
              emit(state.copyWith(currentPage: 0, queationList: initialData.data ?? []));
            },
            (data) async {
              emit(state.copyWith(currentPage: 0, queationList: data.data));
            },
          )
          .catchError((onError) {
            Utils.closeLoader();
            print("QuestionData:: onError ${onError.message}");
            // Use fallback data when error occurs
            final initialData = QueationModel.getInitialData();
            emit(state.copyWith(currentPage: 0, queationList: initialData.data ?? []));
          });
    } catch (e) {
      Utils.closeLoader();
      print("QuestionData:: catch $e");
      // Use fallback data when exception occurs
      final initialData = QueationModel.getInitialData();
      emit(state.copyWith(currentPage: 0, queationList: initialData.data ?? []));
    }
  }

  void optionSubmit(int page, int optionIndex) async {
    Utils.vibrateDevice(duration: 50);
    // Stop speaking when navigating
    stopSpeakingOnNavigation();

    // Store the selected option for the current question
    Map<int, int> updatedSelectedOptions = Map.from(state.selectedOptions);
    updatedSelectedOptions[page] = optionIndex;

    // Store the answer in survey answers
    final question = state.queationList[page];
    final selectedOption = question.options?[optionIndex];

    if (question.questionidpK != null && selectedOption?.optionidpK != null) {
      final surveyAnswer = SurveyAnswer(questionId: question.questionidpK!, optionId: selectedOption!.optionidpK!);

      // Update survey answers list
      List<SurveyAnswer> updatedSurveyAnswers = List.from(state.surveyAnswers);

      // Remove existing answer for this question if any
      updatedSurveyAnswers.removeWhere((answer) => answer.questionId == question.questionidpK);

      // Add new answer
      updatedSurveyAnswers.add(surveyAnswer);

      emit(state.copyWith(currentPage: page + 1, selectedOptions: updatedSelectedOptions, surveyAnswers: updatedSurveyAnswers));
    } else {
      emit(state.copyWith(currentPage: page + 1, selectedOptions: updatedSelectedOptions));
    }
  }

  void showPreviewQuestion(int currentPage) {
    if (currentPage != 0) {
      stopSpeakingOnNavigation();
      emit(state.copyWith(currentPage: currentPage - 1));
    }
  }

  void skipQuestion(int currentPage) {
    if (currentPage >= 8) {
      return;
    }
    if (currentPage < state.queationList.length - 1) {
      stopSpeakingOnNavigation();
      emit(state.copyWith(currentPage: 8));
    }
  }

  bool isQuestionAnswered(int questionIndex) {
    return state.selectedOptions.containsKey(questionIndex);
  }

  bool areAllQuestionsAnswered() {
    return state.selectedOptions.length == state.queationList.length;
  }

  bool canNavigateToNext(int currentPage) {
    return state.selectedOptions.containsKey(currentPage) || currentPage >= state.queationList.length - 1;
  }

  bool canSkipQuestion(int currentPage) {
    return currentPage < 8;
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

  void stopSpeakingOnNavigation() {
    if (state.isSpeaking) {
      stopSpeaking();
    }
  }

  // Update username in state
  void updateUserName(String userName) async {
    if(userName.isNotEmpty){
      await AppPreference().set(key: AppPreference.KEY_USER_FIRST_NAME, value: userName);
    }
    AppService.initializeUserData();
  }

  // Form validation for name and age fields
  void checkFormValidation({required String name, required String age}) {
    if(!state.nameIsAvailable){
      if (name.trim().isEmpty) {
        emit(state.copyWith(isFormValid: false));
        return;
      } else if (age.trim().isEmpty) {
        emit(state.copyWith(isFormValid: false));
        return;
      }
    }

    final ageValue = int.tryParse(age.trim());

    if (ageValue == null) {
      emit(state.copyWith(isFormValid: false));
      return;
    }

    print("Age Value: $ageValue");
    if (ageValue < 15 || ageValue > 120) {
      emit(state.copyWith(isFormValid: false, error: "You must be at least 15 years old to use Legacy Sync.",));
      return;
      // ageValue == null ? "Age cannot be empty" :
    }
    emit(state.copyWith(isFormValid: true,error: null));
  }

  // Update name and age text inputs
  void updateNameAndAge({required String name, required String age}) {
    emit(state.copyWith(userNameText: name, userAgeText: age));
  }

  // Get current survey answers for debugging
  void submitSurveyAnswers(BuildContext context) async {
    try {
      Utils.showLoader();
      final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      List<SurveyAnswer> updatedSurveyAnswers = List.from(state.surveyAnswers);
      updatedSurveyAnswers.removeWhere((answer) => (answer.answerTextAge != null && answer.answerTextAge!.isNotEmpty) || (answer.answerTextName != null && answer.answerTextName!.isNotEmpty));
      updatedSurveyAnswers.add(SurveyAnswer(questionId: 11, answerTextAge: state.userAgeText, answerTextName: state.userNameText));

      emit(state.copyWith(surveyAnswers: updatedSurveyAnswers));
      SurveySubmission surveySubmission = SurveySubmission(userId: userID, answers: state.surveyAnswers);
      Map<String, dynamic> payload = surveySubmission.toJson();
      final result = await questionCase.submitSurvey(payload);
      Utils.closeLoader();
      result.fold(
        (failure) {
          Utils.showInfoDialog(context: context, title: failure.message ?? "Something went wrong");
        },
        (data) {
          AppPreference().setBool(key: AppPreference.KEY_SURVEY_SUBMITTED, value: true);
          Navigator.pushNamed(context, RoutesName.ANALYSIS_SCREEN);
        },
      );
    } catch (e) {
      print("Exception ::: $e");
      Utils.closeLoader();
    }
  }
}
