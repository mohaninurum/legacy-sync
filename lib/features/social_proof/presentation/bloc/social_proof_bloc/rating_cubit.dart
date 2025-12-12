import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:legacy_sync/features/social_proof/data/repositories/social_proof_repository_impl.dart';
import 'package:legacy_sync/features/social_proof/domain/usecases/get_ratings_usecase.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingState.initial());
  final repo = SocialProofRepositoryImpl();
  final InAppReview inAppReview = InAppReview.instance;

  void requestReview() async {
    if (await inAppReview.isAvailable()) {
      emit(state.copyWith(isRequested: true, errorMessage: null));
      inAppReview.requestReview();

    }
  }

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final usecase = GetRatingsUseCase(repo);
      final result = await usecase();
      result.fold((failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)), (items) => emit(state.copyWith(isLoading: false, items: items, errorMessage: null)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
