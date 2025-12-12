import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/onboarding/data/model/onboarding_page.dart';
import 'package:legacy_sync/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:legacy_sync/core/images/images.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingPageModel> getOnboardingPages() {
    // Static content for now; could be fetched from API later
    return const [
      OnboardingPageModel(
        title: 'The Science of a Life Well Told.',
        description:
            "Research shows that sharing your life story isn't just a gift for others – it's a profound gift for your own well-being. It strengthens purpose, connection, and boosts mental clarity. Your journey, shared.",
        richText: ' ~ "Life Review Therapy" Dr. Robert Butler',
        imagePath: LottieFiles.insights1,
      ),
      OnboardingPageModel(
        title: 'The Roots of Resilience.',
        description:
            'Knowing their family story builds stronger, more resilient children. Research highlights that a deep connection to family history fosters identity, self-esteem, and coping skills for future generations. Your legacy is their strength."',
        richText: ' ~ Marshall Duke, Robyn Fivush, and Sara Feingold at Emory University.',
        imagePath: LottieFiles.insights2,
      ),
      OnboardingPageModel(
        title: 'The Enduring Power of Your Voice.',
        description:
            'More than words, your voice carries unique emotional power. Studies confirm that hearing the voice of a loved one strengthens connection and memory, creating a bond that transcends time. We are here to preserve that precious sound."',
        richText: ' ~ Dr. Pascal Belin Professor of Neuroscience, University of Glasgow',
        imagePath: LottieFiles.insights3,
      ),
      OnboardingPageModel(
        title: 'Wisdom, Unlocked for Generations.',
        description:
            'The sharing of wisdom across generations is a cornerstone of human progress and personal fulfillment. Your life is insights are an invaluable resource, ready to guide and inspire those who follow. Unlock your legacy of Wisdom."',
        richText: ' ~ Dr. Karl Pillemer Professor of Human Development, Cornell University',
        imagePath: LottieFiles.insights4,
      ),
    ];
  }
}
