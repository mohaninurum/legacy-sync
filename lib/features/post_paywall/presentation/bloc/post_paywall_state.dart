import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/post_paywall/data/model/post_paywall_page.dart';

class PostPaywallState extends Equatable {
  final int currentPageIndex;
  final bool isLastPage;
  final List<PostPaywallPageModel> pages;

  const PostPaywallState({
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.pages = const [],
  });

  PostPaywallState copyWith({
    int? currentPageIndex,
    bool? isLastPage,
    List<PostPaywallPageModel>? pages,
  }) {
    return PostPaywallState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, isLastPage, pages];
}
