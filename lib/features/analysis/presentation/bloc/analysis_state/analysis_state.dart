import 'package:equatable/equatable.dart';

class AnalysisState extends Equatable {
  final double currentPercentage;
  final double targetPercentage;
  final bool isAnimating;
  final bool isCompleted;
  final String? error;

  const AnalysisState({
    this.currentPercentage = 0.0,
    this.targetPercentage = 0.0,
    this.isAnimating = false,
    this.isCompleted = false,
    this.error,
  });

  AnalysisState copyWith({
    double? currentPercentage,
    double? targetPercentage,
    bool? isAnimating,
    bool? isCompleted,
    String? error,
  }) {
    return AnalysisState(
      currentPercentage: currentPercentage ?? this.currentPercentage,
      targetPercentage: targetPercentage ?? this.targetPercentage,
      isAnimating: isAnimating ?? this.isAnimating,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    currentPercentage,
    targetPercentage,
    isAnimating,
    isCompleted,
    error,
  ];
}
