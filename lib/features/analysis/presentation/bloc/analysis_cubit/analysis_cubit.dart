import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_state/analysis_state.dart';
import 'dart:math';

class AnalysisCubit extends Cubit<AnalysisState> {
  AnalysisCubit() : super(const AnalysisState());

  void initializeAnalysis() {
    // Generate random target percentage (100%)
    final targetPercentage = 100.0;

    emit(state.copyWith(targetPercentage: targetPercentage));
  }

  void startAnalysis() {
    emit(state.copyWith(currentPercentage: 0.0, isAnimating: true, isCompleted: false));
  }

  void updateProgress(double currentPercentage) {
    if (currentPercentage.toInt() % 2 == 0) {
      Utils.vibrateDevice(duration: Platform.isIOS ? 3 : 10);
    }
    emit(state.copyWith(currentPercentage: currentPercentage));
  }

  void completeAnalysis() {
    emit(state.copyWith(currentPercentage: state.targetPercentage, isAnimating: false, isCompleted: true));
  }

  void resetAnalysis() {
    initializeAnalysis();
  }
}
