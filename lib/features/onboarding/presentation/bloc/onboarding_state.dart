import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/onboarding/data/model/onboarding_page.dart';

class OnboardingState extends Equatable {
  final int currentPageIndex;
  final bool isLastPage;
  final List<OnboardingPageModel> pages;

  const OnboardingState({
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.pages = const [],
  });

  OnboardingState copyWith({
    int? currentPageIndex,
    bool? isLastPage,
    List<OnboardingPageModel>? pages,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, isLastPage, pages];
}
