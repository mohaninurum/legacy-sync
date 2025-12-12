import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/social_proof/data/repositories/social_proof_repository_impl.dart';
import 'package:legacy_sync/features/social_proof/domain/usecases/get_goals_usecase.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/choose_your_goals_state.dart';

class ChooseYourGoalsCubit extends Cubit<ChooseYourGoalsState> {
  ChooseYourGoalsCubit() : super(ChooseYourGoalsState.initial());
  final repo = SocialProofRepositoryImpl();
  final FlutterTts flutterTts = FlutterTts();

  @override
  Future<void> close() async {
    await flutterTts.stop();
    return super.close();
  }

  Future<void> loadGoals() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final usecase = GetGoalsUseCase(repo);
      final goals = await usecase.call();
      goals.fold((failure) {
        print("Error1 ${failure.message}");
        emit(state.copyWith(isLoading: false, errorMessage: failure.message.toString()));
      }, (data) => {emit(state.copyWith(isLoading: false, goals: data.data, errorMessage: null))});
    } catch (e) {
      print("Error2 ${e.toString()}");
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void toggleGoalSelection(int goalId) {
    stopSpeaking();
    Utils.vibrateDevice(duration: 50);
    final updatedGoals =
        state.goals.map((goal) {
          if (goal.goalIdPk == goalId) {
            return goal.copyWith(isSelected: !goal.isSelected);
          }
          return goal;
        }).toList();

    emit(state.copyWith(goals: updatedGoals));
  }

  void selectAllGoals() {
    final updatedGoals =
        state.goals.map((goal) {
          return goal.copyWith(isSelected: true);
        }).toList();

    emit(state.copyWith(goals: updatedGoals));
  }

  void deselectAllGoals() {
    final updatedGoals =
        state.goals.map((goal) {
          return goal.copyWith(isSelected: false);
        }).toList();

    emit(state.copyWith(goals: updatedGoals));
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
}
