import 'package:equatable/equatable.dart';

class AnalysisCompleteState extends Equatable {
  final int currentGraphIndex;
  final bool isAnimating;
  final bool isCompleted;

  const AnalysisCompleteState({
    this.currentGraphIndex = 0,
    this.isAnimating = false,
    this.isCompleted = false,
  });

  AnalysisCompleteState copyWith({
    int? currentGraphIndex,
    bool? isAnimating,
    bool? isCompleted,
  }) {
    return AnalysisCompleteState(
      currentGraphIndex: currentGraphIndex ?? this.currentGraphIndex,
      isAnimating: isAnimating ?? this.isAnimating,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentGraphIndex, isAnimating, isCompleted];
}
