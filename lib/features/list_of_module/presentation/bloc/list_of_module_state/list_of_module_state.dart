import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';

class ListOfModuleState {
  final bool isLoading;
  final bool isDataSave;
  final bool isQuestionContinue;
  final QuestionData data;
  final int totalAnswered;
  final String? errorMessage;
  final QuestionItems currentQuestionItems;

  const ListOfModuleState({required this.isDataSave,required this.isLoading,required this.isQuestionContinue, required this.data, required this.currentQuestionItems,required this.totalAnswered, this.errorMessage});

  factory ListOfModuleState.initial() => ListOfModuleState(isDataSave: false,isLoading: false,isQuestionContinue: false, currentQuestionItems: QuestionItems.empty(),data: QuestionData.empty(),totalAnswered: 0);

  ListOfModuleState copyWith({bool? isDataSave,bool? isSpeaking, bool? isQuestionContinue, bool? isLoading, QuestionData? data,QuestionItems? currentQuestionItems, String? errorMessage, int? totalAnswered}) {
    return ListOfModuleState(isQuestionContinue: isQuestionContinue??this.isQuestionContinue, currentQuestionItems: currentQuestionItems ?? this.currentQuestionItems,isLoading: isLoading ?? this.isLoading,isDataSave: isDataSave ?? this.isDataSave, data: data ?? this.data, errorMessage: errorMessage ?? this.errorMessage, totalAnswered: totalAnswered ?? this.totalAnswered);
  }
}
