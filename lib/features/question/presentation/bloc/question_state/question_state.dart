import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';
import 'package:legacy_sync/features/question/data/model/survey_submission.dart';

class QuestionState extends Equatable {
  final int currentPage;
  final List<Data> queationList;
  final String? error;
  final Map<int, int>
  selectedOptions; // Map<questionIndex, selectedOptionIndex>
  final bool isSpeaking; // Track if text-to-speech is currently playing
  final bool isFormValid;
  final bool nameIsAvailable;
  final List<SurveyAnswer> surveyAnswers; // Store all survey answers
  final String? userNameText; // Store the name from text input
  final String? userAgeText; // Store the age from text input

  QuestionState( {
    int? currentPage,
    List<Data>? queationList,
    this.error,
    Map<int, int>? selectedOptions,
    bool? isSpeaking,
    bool? isFormValid,
    bool? nameIsAvailable,
    List<SurveyAnswer>? surveyAnswers,
    this.userNameText,
    this.userAgeText,
  }) : currentPage = currentPage ?? 0,
       queationList = queationList ?? [],
       selectedOptions = selectedOptions ?? {},
       isSpeaking = isSpeaking ?? false,
        nameIsAvailable = nameIsAvailable ?? false,
       isFormValid = isFormValid ?? false,
       surveyAnswers = surveyAnswers ?? [];

  QuestionState copyWith({
    int? currentPage,
    List<Data>? queationList,
    String? error,
    Map<int, int>? selectedOptions,
    bool? isSpeaking,
    bool? nameIsAvailable,
    bool? isFormValid,
    List<SurveyAnswer>? surveyAnswers,
    String? userNameText,
    String? userAgeText,
  }) {
    return QuestionState(
      nameIsAvailable: nameIsAvailable ?? this.nameIsAvailable,
      currentPage: currentPage ?? this.currentPage,
      queationList: queationList ?? this.queationList,
      error: error,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isFormValid: isFormValid ?? this.isFormValid,
      surveyAnswers: surveyAnswers ?? this.surveyAnswers,
      userNameText: userNameText ?? this.userNameText,
      userAgeText: userAgeText ?? this.userAgeText,
    );
  }

  @override
  List<Object?> get props => [
    currentPage,
    queationList,
    error,
    selectedOptions,
    isSpeaking,
    isFormValid,
    surveyAnswers,
    userNameText,
    userAgeText,
  ];
}
