import 'package:legacy_sync/features/onboarding/data/model/onboarding_page.dart';
import 'package:legacy_sync/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingPagesUseCase {
  final OnboardingRepository repository;
  GetOnboardingPagesUseCase(this.repository);

  List<OnboardingPageModel> call() => repository.getOnboardingPages();
}
