import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/legacy_wrapped/data/repositories/legacy_wrapped_repository_impl.dart';
import 'package:legacy_sync/features/legacy_wrapped/domain/usecases/get_legacy_wrapped_pages.dart';
import 'package:legacy_sync/features/legacy_wrapped/presentation/bloc/state/legacy_wrapped_state.dart';

class LegacyWrappedCubit extends Cubit<LegacyWrappedState> {
  LegacyWrappedCubit() : super(const LegacyWrappedState());

  void loadPages() {
    final repo = LegacyWrappedRepositoryImpl();
    final usecase = GetLegacyWrappedPagesUseCase(repo);
    final pages = usecase();
    emit(state.copyWith(pages: pages, isLastPage: pages.isNotEmpty ? state.currentPageIndex == pages.length - 1 : false));
  }

  void setPage(int index, {required int totalPages}) {
    emit(state.copyWith(currentPageIndex: index, isLastPage: index == totalPages - 1));
  }

  void next({required int totalPages}) {
    final nextIndex = (state.currentPageIndex + 1).clamp(0, totalPages - 1);
    emit(state.copyWith(currentPageIndex: nextIndex, isLastPage: nextIndex == totalPages - 1));
  }

  void skipToEnd({required int totalPages}) {
    final lastIndex = totalPages - 1;
    emit(state.copyWith(currentPageIndex: lastIndex, isLastPage: true));
  }
}
