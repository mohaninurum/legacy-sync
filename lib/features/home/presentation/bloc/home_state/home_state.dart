import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/navigation_tab_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';

class HomeState {
  final bool isLoading;
  final bool isFirstVisit;
  final List<JourneyCardModel> journeyCards;
  final List<PipeAnimationModel> pipeAnimations;
  final List<FriendsDataList>? friendsList;
  final NavigationTab selectedTab;
  final bool isJourneyAnimating;
  final String? errorMessage;
  final String referalCode;

  const HomeState({
    this.isLoading = false,
    this.isFirstVisit = false,
    required this.journeyCards,
    required this.pipeAnimations,
    this.selectedTab = NavigationTab.journey,
    this.isJourneyAnimating = false,
    this.errorMessage,
    this.friendsList,
    this.referalCode = "",
  });

  factory HomeState.initial() {
    return HomeState(
      journeyCards: JourneyCardModel.getDefaultCards(),
      pipeAnimations: PipeAnimationModel.getDefaultPipes(),
      referalCode: "",
      isFirstVisit: false
    );
  }

  HomeState copyWith({
    bool? isLoading,
    bool? isFirstVisit,
    List<JourneyCardModel>? journeyCards,
    List<PipeAnimationModel>? pipeAnimations,
    List<FriendsDataList>? friendsList,
    NavigationTab? selectedTab,
    bool? isJourneyAnimating,
    String? errorMessage,
    String? referalCode,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      referalCode: referalCode ?? this.referalCode,
      journeyCards: journeyCards ?? this.journeyCards,
      friendsList: friendsList ?? this.friendsList,
      pipeAnimations: pipeAnimations ?? this.pipeAnimations,
      selectedTab: selectedTab ?? this.selectedTab,
      isJourneyAnimating: isJourneyAnimating ?? this.isJourneyAnimating,
      errorMessage: errorMessage ?? this.errorMessage,
      isFirstVisit: isFirstVisit ?? this.isFirstVisit,
    );
  }

  bool get isJourneyTab => selectedTab == NavigationTab.journey;
}
