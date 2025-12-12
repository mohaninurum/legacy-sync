import 'package:legacy_sync/features/social_proof/data/model/credibility_item.dart';

class CredibilityState {
  final bool isLoading;
  final List<CredibilityItem> items;
  final String? errorMessage;

  const CredibilityState({required this.isLoading, required this.items, this.errorMessage});

  factory CredibilityState.initial() => const CredibilityState(isLoading: false, items: []);

  CredibilityState copyWith({bool? isLoading, List<CredibilityItem>? items, String? errorMessage}) {
    return CredibilityState(isLoading: isLoading ?? this.isLoading, items: items ?? this.items, errorMessage: errorMessage);
  }
}
