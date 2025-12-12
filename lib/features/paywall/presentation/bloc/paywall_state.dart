import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/paywall/data/model/paywall_page.dart';

class PaywallState extends Equatable {
  final int currentPageIndex;
  final bool isLastPage;
  final List<PaywallPageModel> pages;

  const PaywallState({
    this.currentPageIndex = 0,
    this.isLastPage = false,
    this.pages = const [],
  });

  PaywallState copyWith({
    int? currentPageIndex,
    bool? isLastPage,
    List<PaywallPageModel>? pages,
  }) {
    return PaywallState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentPageIndex, isLastPage, pages];
}
