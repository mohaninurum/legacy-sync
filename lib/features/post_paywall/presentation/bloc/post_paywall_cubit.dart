import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/post_paywall/data/repositories/post_paywall_repository_impl.dart';
import 'package:legacy_sync/features/post_paywall/domain/usecases/get_post_paywall_pages.dart';
import 'package:legacy_sync/features/post_paywall/presentation/bloc/post_paywall_state.dart';

class PostPaywallCubit extends Cubit<PostPaywallState> {
  PostPaywallCubit() : super(const PostPaywallState());

  void loadPages() {
    final repo = PostPaywallRepositoryImpl();
    final usecase = GetPostPaywallPagesUseCase(repo);
    final pages = usecase();
    emit(
      state.copyWith(
        pages: pages,
        isLastPage:
            pages.isNotEmpty
                ? state.currentPageIndex == pages.length - 1
                : false,
      ),
    );
  }

  void setPage(int index, {required int totalPages}) {
    emit(
      state.copyWith(
        currentPageIndex: index,
        isLastPage: index == totalPages - 1,
      ),
    );
  }

  void next({required int totalPages}) {
    final nextIndex = (state.currentPageIndex + 1).clamp(0, totalPages - 1);
    emit(
      state.copyWith(
        currentPageIndex: nextIndex,
        isLastPage: nextIndex == totalPages - 1,
      ),
    );
  }

  void skipToEnd({required int totalPages}) {
    final lastIndex = totalPages - 1;
    emit(state.copyWith(currentPageIndex: lastIndex, isLastPage: true));
  }
}
