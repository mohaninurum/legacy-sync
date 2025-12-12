import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/encryption_service.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/navigation_tab_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';
import 'package:legacy_sync/features/home/domain/usecases/home_usecases.dart';
import 'package:legacy_sync/features/home/domain/usecases/navigate_to_module_usecase.dart';
import 'package:legacy_sync/features/home/presentation/bloc/home_state/home_state.dart';

class HomeCubitBackUp extends Cubit<HomeState> {
  HomeCubitBackUp() : super(HomeState.initial());

  final HomeUseCases _homeUseCases = HomeUseCases();
  AppPreference appPreference = AppPreference();

  void initializeHome(BuildContext context) async {
    final isFirstVisit = await AppPreference().getBool(key: AppPreference.KEY_USER_FIRST_VISIT);
    if(!isFirstVisit){
      await AppPreference().setBool(key: AppPreference.KEY_USER_FIRST_VISIT, value: true);
    }
    emit(state.copyWith(isFirstVisit: isFirstVisit));

    final referalCode = await AppPreference().get(key: AppPreference.KEY_REFERRAL_CODE);
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(referalCode: referalCode, isLoading: true));
    final result = await _homeUseCases.getHomeModule(userId: userId);
    emit(state.copyWith(isLoading: false));
    result.fold((l) {
      emit(state.copyWith(isLoading: false));
      Utils.showInfoDialog(context: context, title: l.message??"Something went wrong");
    }, (r) async {
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
        appPreference.saveCachedModelList<JourneyCardModel>(cacheKey: EncryptionService.secretKey, modelList: journeyCards, toJson: (model) => model.toJson());
        appPreference.saveCachedModelList<PipeAnimationModel>(cacheKey: EncryptionService.secretKey, modelList: pipeAnimations, toJson: (model) => model.toJson());
      }
    });

  }
  void refreshHomeModules(int index) async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final result = await _homeUseCases.getHomeModule(userId: userId);
    result.fold((l) {
    }, (r) async {
      if(r.data != null){
        List<JourneyCardModel> journeyCards = List<JourneyCardModel>.from(state.journeyCards);
        List<PipeAnimationModel> pipeAnimations = List<PipeAnimationModel>.from(state.pipeAnimations);
        List<JourneyCardDataModel> mJourneyCards = r.data!;
        for(int i = index;i<mJourneyCards.length;i++){
          final data = mJourneyCards[i];
          final isEnabled = !(data.isLocked ?? false);
          journeyCards[i] = journeyCards[i].copyWith(title: data.moduleTitle,description: data.moduleDescription,id: data.moduleIdPK,isEnabled: isEnabled,isAnimating: isEnabled);
        }
        // Enable pipes between consecutive enabled cards
        for (int i = index; i < journeyCards.length - 1; i++) {
          if (journeyCards[i].isEnabled && journeyCards[i + 1].isEnabled) {
            await Future.delayed(const Duration(milliseconds: 300), () async {
              await startJourneyAnimation(i);
            });

          }
        }
        emit(state.copyWith(isLoading: false, pipeAnimations: pipeAnimations, journeyCards: journeyCards));
      }
    });
  }


  void onJourneyCardTapped(int cardIndex) {
    final currentCards = List<JourneyCardModel>.from(state.journeyCards);
    final currentPipes = List<PipeAnimationModel>.from(state.pipeAnimations);

    // Check if card is enabled and not animating
    if (state.isJourneyAnimating || !currentCards[cardIndex].isEnabled) {
      return;
    }

    // Check if all cards are enabled (except first) OR if last card is tapped
    bool allEnabled = currentCards.every((card) => card.isEnabled);

    if (allEnabled || cardIndex == 7) {
      // Reset all cards except first and disable all pipes
      final resetCards =
          currentCards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            return card.copyWith(isEnabled: index == 0, isAnimating: false);
          }).toList();

      final resetPipes = currentPipes.map((pipe) => pipe.copyWith(isEnabled: false, animationProgress: 0.0, isAnimating: false)).toList();

      emit(state.copyWith(journeyCards: resetCards, pipeAnimations: resetPipes, isJourneyAnimating: false));
      return;
    }

    // Start animation for the tapped card
    emit(state.copyWith(isJourneyAnimating: true));
    startJourneyAnimation(cardIndex);
  }

  void onNavigationTabChanged(int tabIndex) {
    final selectedTab = NavigationTab.fromIndex(tabIndex);
    emit(state.copyWith(selectedTab: selectedTab));
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

  void resetJourney() {
    final resetCards =
        state.journeyCards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;
          return card.copyWith(isEnabled: index == 0, isAnimating: false);
        }).toList();

    // Reset all pipes to disabled state
    final resetPipes = state.pipeAnimations.map((pipe) => pipe.copyWith(isEnabled: false, animationProgress: 0.0, isAnimating: false)).toList();

    emit(state.copyWith(journeyCards: resetCards, pipeAnimations: resetPipes, isJourneyAnimating: false));
  }

  void onContinueLegacyPressed(BuildContext context) {
    final cards = state.journeyCards;
    dynamic navigationArgs = {};
    int lastEnabledIndex = -1;
    // Find the last enabled card
    for(int i = 0; i < cards.length; i++){
      final card = cards[i];
      if(card.isEnabled){
        lastEnabledIndex = i;
      }
    }
    // If we found at least one enabled card, use it for navigation
    if(lastEnabledIndex != -1){
      final lastEnabledCard = cards[lastEnabledIndex];
       navigationArgs = NavigateToModuleUsecase.execute(lastEnabledCard);
      navigationArgs.addAll({
        "preExpanded": true,
      });
    }

    Navigator.pushNamed(context, RoutesName.LIST_OF_MODULE, arguments: navigationArgs);
  }

  void getFriendsList() async {
    final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final result = await _homeUseCases.getFriendsList(userId: userID);
    result.fold((l) {}, (data) {
      if (data.data != null) {
        emit(state.copyWith(friendsList: data.data!));
      }
    });
  }

  void addFriend({required BuildContext context, required String code}) async {
    final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    Map<String, dynamic> body = {"user_id": userID, "referal_code": code};
    try {
      Utils.showLoader();
      final result = await _homeUseCases.addFriend(body: body);
      Utils.closeLoader();
      result.fold(
        (l) {
          Utils.showInfoDialog(context: context, title: "Failed", content: l.message ?? "Something went wrong");
        },
        (data) {
          Utils.showInfoDialog(context: context, title: "Success", content: data.message ?? "Friend added succesfully");
          if (data.data != null) {
            List<FriendsDataList>? friendsList = List<FriendsDataList>.from(state.friendsList ?? []);
            FriendsDataList friendsDataList = FriendsDataList();
            friendsDataList.email = data.data?.email ?? "";
            friendsDataList.userIdPK = data.data?.userIdPK ?? 0;
            friendsDataList.firstName = data.data?.firstName ?? "";
            friendsDataList.lastName = data.data?.lastName ?? "";
            friendsDataList.referalCode = data.data?.referalCode ?? "";
            friendsList.add(friendsDataList);
            emit(state.copyWith(friendsList: friendsList));
          }
        },
      );
    } catch (e) {
      Utils.showLoader();
      Utils.showInfoDialog(context: context, title: "Failed", content: e.toString() ?? "Something went wrong");
    }
  }
}
