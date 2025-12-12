import 'package:legacy_sync/features/social_proof/data/model/rating_item.dart';

class RatingState {
  final bool isLoading;
  final bool isRequested;
  final List<RatingItem> items;
  final String? errorMessage;

  const RatingState({
    required this.isLoading,
    required this.isRequested,
    required this.items,
    this.errorMessage,
  });

  factory RatingState.initial() =>
      const RatingState(isLoading: false,isRequested: false, items: []);

  RatingState copyWith({
    bool? isLoading,
    bool? isRequested,
    List<RatingItem>? items,
    String? errorMessage,
  }) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      isRequested: isRequested ?? this.isRequested,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
