import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';

class CardLoaded extends Equatable {
  final CardModel card;
  final List<GradientOption> gradientOptions;
  final List<String> textsList;
  final String titleText;
  final int curentIndex;
  final int lastIndex;
  final bool showCustomization;
  final bool showCard;

  const CardLoaded({
    required this.lastIndex,
    required this.curentIndex,
    required this.titleText,
    required this.card,
    required this.gradientOptions,
    required this.textsList,
    required this.showCustomization,
    required this.showCard,
  });

  factory CardLoaded.initial() => CardLoaded(
    curentIndex: 0,
    lastIndex: 0,
    titleText: "",
    card: CardModel.empty(),
    gradientOptions: const [],
    showCard: false,
    showCustomization: false,
    textsList: const [],
  );

  CardLoaded copyWith({
    String? titleText,
    int? lastIndex,
    int? curentIndex,
    CardModel? card,
    List<GradientOption>? gradientOptions,
    List<String>? texts,
    bool? showCustomization,
    bool? showCard,
  }) {
    return CardLoaded(
      curentIndex: curentIndex ?? this.curentIndex,
      lastIndex: lastIndex ?? this.lastIndex,
      titleText: titleText ?? this.titleText,
      card: card ?? this.card,
      gradientOptions: gradientOptions ?? this.gradientOptions,
      textsList: texts ?? this.textsList,
      showCustomization: showCustomization ?? this.showCustomization,
      showCard: showCard ?? this.showCard,
    );
  }

  @override
  List<Object?> get props => [
    card,
    gradientOptions,
    showCustomization,
    showCard,
    textsList,
    titleText,
    curentIndex,
    lastIndex,
  ];
}
