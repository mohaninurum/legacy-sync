import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';

class FriendsProfileState extends Equatable {
  final bool isLoading;
  final List<JourneyCardModel> journeyCards;
  final List<PipeAnimationModel> pipeAnimations;
  final bool isJourneyAnimating;
  final String? errorMessage;

  const FriendsProfileState({
    this.isLoading = false,
    this.journeyCards = const [],
    this.pipeAnimations = const [],
    this.isJourneyAnimating = false,
    this.errorMessage,
  });

  FriendsProfileState copyWith({
    bool? isLoading,
    List<JourneyCardModel>? journeyCards,
    List<PipeAnimationModel>? pipeAnimations,
    bool? isJourneyAnimating,
    String? errorMessage,
  }) {
    return FriendsProfileState(
      isLoading: isLoading ?? this.isLoading,
      journeyCards: journeyCards ?? this.journeyCards,
      pipeAnimations: pipeAnimations ?? this.pipeAnimations,
      isJourneyAnimating: isJourneyAnimating ?? this.isJourneyAnimating,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    journeyCards,
    pipeAnimations,
    isJourneyAnimating,
    errorMessage,
  ];
}
