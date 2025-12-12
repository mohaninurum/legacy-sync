import 'package:legacy_sync/features/onboarding/data/model/onboarding_page.dart';

abstract class OnboardingRepository {
  List<OnboardingPageModel> getOnboardingPages();
}
