import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/legacy_wrapped/data/model/legacy_wrapped_page.dart';

class LegacyWrappedState extends Equatable {
  final int currentPageIndex;
  final bool isLastPage;
  final List<LegacyWrappedPageModel> pages;

  const LegacyWrappedState({
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.pages = const [],
  });

  LegacyWrappedState copyWith({
    int? currentPageIndex,
    bool? isLastPage,
    List<LegacyWrappedPageModel>? pages,
  }) {
    return LegacyWrappedState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, isLastPage, pages];
}
