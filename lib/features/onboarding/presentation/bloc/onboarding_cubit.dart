import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:legacy_sync/features/onboarding/domain/usecases/get_onboarding_pages.dart';
import 'package:legacy_sync/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void loadPages() {
    final repo = OnboardingRepositoryImpl();
    final usecase = GetOnboardingPagesUseCase(repo);
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
