import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart' show Utils;
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';

import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';
import '../../../domain/usecases/friends_profile_usecase.dart';
import '../profile_state/friends_profile_state.dart';

class FriendsProfileCubit extends Cubit<FriendsProfileState> {
  final FriendsProfileUseCase _profileUseCase = FriendsProfileUseCase();

  FriendsProfileCubit() : super(const FriendsProfileState());

  // void getCard() {
  //   emit(state.copyWith(journeyCards: JourneyCardModel.getDefaultCards(),pipeAnimations: PipeAnimationModel.getDefaultPipes()));
  //
  // }
  void initializeProfile(BuildContext context,int friendId) async {
    emit(state.copyWith(journeyCards: JourneyCardModel.getDefaultCards(), pipeAnimations: PipeAnimationModel.getDefaultPipes()));
    try {
      // Start loading
      emit(state.copyWith(isLoading: true));

      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      final result = await _profileUseCase.getHomeModule(userId: friendId);
      result.fold(
        (l) {
          emit(state.copyWith(isLoading: false));
          Utils.showInfoDialog(context: context, title: l.message ?? "Something went wrong");
        },
        (r) async {
          if(r.data != null){
            List<JourneyCardModel> journeyCards = List<JourneyCardModel>.from(state.journeyCards);
            List<PipeAnimationModel> pipeAnimations = List<PipeAnimationModel>.from(state.pipeAnimations);
            List<JourneyCardDataModel> mJourneyCards = r.data!;
            for(int i = 0;i<mJourneyCards.length;i++){
              final data = mJourneyCards[i];
              final isEnabled = !(data.isLocked ?? false);
              journeyCards[i] = journeyCards[i].copyWith(title: data.moduleTitle,description: data.moduleDescription,id: data.moduleIdPK,isEnabled: isEnabled,isAnimating: isEnabled);
            }
            // Enable pipes between consecutive enabled cards
            for (int i = 0; i < journeyCards.length - 1; i++) {
              if (journeyCards[i].isEnabled && journeyCards[i + 1].isEnabled) {
                await Future.delayed(const Duration(milliseconds: 300), () async {
                  await startJourneyAnimation(i);
                });

              }
            }
            emit(state.copyWith(isLoading: false, pipeAnimations: pipeAnimations, journeyCards: journeyCards));
          } else {
            emit(state.copyWith(isLoading: false));
          }
        },
      );
    } catch (e) {
      print("FriendsProfileCubit: Exception caught: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> startJourneyAnimation(int cardIndex) async {
    print("Cubit: JourneyAnimationStarted for card $cardIndex");
    final currentCards = List<JourneyCardModel>.from(state.journeyCards);
    final currentPipes = List<PipeAnimationModel>.from(state.pipeAnimations);

    // Update the tapped card to be animating
    currentCards[cardIndex] = currentCards[cardIndex].copyWith(isAnimating: true);

    // Start pipe animation if not the last card
    if (cardIndex < 7) {
      currentPipes[cardIndex] = currentPipes[cardIndex].copyWith(isAnimating: true, animationProgress: 0.0);
      print("Cubit: Starting pipe animation for index $cardIndex");
    }

    emit(state.copyWith(journeyCards: currentCards, pipeAnimations: currentPipes));

    // Auto-complete animation after delay (simulating the pipe filling time)
    if (cardIndex < 7) {
      await Future.delayed(const Duration(milliseconds: 2200));
      print("Cubit: Auto-completing animation for card $cardIndex");
      completeJourneyAnimation(cardIndex);
    } else {
      completeJourneyAnimation(cardIndex);
    }
  }

  void completeJourneyAnimation(int cardIndex) {
    final currentCards = List<JourneyCardModel>.from(state.journeyCards);
    final currentPipes = List<PipeAnimationModel>.from(state.pipeAnimations);

    // Complete the animation for the tapped card
    currentCards[cardIndex] = currentCards[cardIndex].copyWith(isAnimating: false);

    // Enable the pipe and next card if not the last card
    if (cardIndex < 7) {
      currentPipes[cardIndex] = currentPipes[cardIndex].copyWith(isEnabled: true, isAnimating: false, animationProgress: 1.0);

      // Enable the next card
      if (cardIndex + 1 < currentCards.length) {
        currentCards[cardIndex + 1] = currentCards[cardIndex + 1].copyWith(isEnabled: true);
      }
    }

    emit(state.copyWith(journeyCards: currentCards, pipeAnimations: currentPipes, isJourneyAnimating: false));
  }
}
