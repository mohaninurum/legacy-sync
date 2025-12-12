import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/social_proof/data/repositories/social_proof_repository_impl.dart';
import 'package:legacy_sync/features/social_proof/domain/usecases/get_credibility_usecase.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/credibility_state.dart';

class CredibilityCubit extends Cubit<CredibilityState> {
  CredibilityCubit() : super(CredibilityState.initial());
  final repo = SocialProofRepositoryImpl();

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final usecase = GetCredibilityUseCase(repo);
      final result = await usecase();
      result.fold((failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)), (items) => emit(state.copyWith(isLoading: false, items: items, errorMessage: null)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
