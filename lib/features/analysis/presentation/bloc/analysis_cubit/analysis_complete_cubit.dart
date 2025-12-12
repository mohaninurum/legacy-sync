import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_state/analysis_complete_state.dart';

class AnalysisCompleteCubit extends Cubit<AnalysisCompleteState> {
  AnalysisCompleteCubit() : super(const AnalysisCompleteState());

  void startAnimation() {
    emit(state.copyWith(isAnimating: true));
  }

  void nextGraph() {
    emit(state.copyWith(isCompleted: true));
    // if (state.currentGraphIndex < 2) {
    //   emit(state.copyWith(currentGraphIndex: state.currentGraphIndex + 1, isAnimating: true));
    // } else {
    //   emit(state.copyWith(isCompleted: true));
    // }
  }

  void completeAnimation() {
    emit(state.copyWith(isAnimating: false));
  }

  void resetState() {
    emit(const AnalysisCompleteState());
  }
}
