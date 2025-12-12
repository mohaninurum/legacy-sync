import 'package:legacy_sync/features/social_proof/data/model/goal_item.dart';

class ChooseYourGoalsState {
  final bool isLoading;
  final bool isSpeaking;
  final List<GoalItem> goals;
  final String? errorMessage;

  const ChooseYourGoalsState({required this.isLoading, required this.isSpeaking, required this.goals, this.errorMessage});

  factory ChooseYourGoalsState.initial() => const ChooseYourGoalsState(isSpeaking: false, isLoading: false, goals: []);

  ChooseYourGoalsState copyWith({bool? isSpeaking, bool? isLoading, List<GoalItem>? goals, String? errorMessage}) {
    return ChooseYourGoalsState(isSpeaking: isSpeaking ?? this.isSpeaking, isLoading: isLoading ?? this.isLoading, goals: goals ?? this.goals, errorMessage: errorMessage ?? this.errorMessage);
  }

  List<GoalItem> get selectedGoals => goals.where((goal) => goal.isSelected).toList();
  bool get hasSelectedGoals => selectedGoals.isNotEmpty;
}
