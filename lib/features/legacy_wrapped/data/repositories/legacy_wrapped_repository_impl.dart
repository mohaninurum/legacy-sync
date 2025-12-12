import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/legacy_wrapped/data/model/legacy_wrapped_page.dart';
import 'package:legacy_sync/features/legacy_wrapped/domain/repositories/legacy_wrapped_repository.dart';
import 'package:legacy_sync/core/images/images.dart';

class LegacyWrappedRepositoryImpl implements LegacyWrappedRepository {
  @override
  List<LegacyWrappedPageModel> getLegacyWrappedPages() {
    // Static content for now; could be fetched from API later
    return [
      const LegacyWrappedPageModel(
        title: 'Your Legacy Journey, Wrapped!',
        description:
            "You've captured stories, shared memories, and planted seeds for generations to come. Let's look at what you've build.",
        richText: '',
        imagePath: LottieFiles.lgw1,
      ),
      const LegacyWrappedPageModel(
        title: 'You\'ve Captured 64 Memories',
        description:
            'From childhood wonders to life-defining moments you\'ve answered 64 deep questions that preserve your',
        richText:
            '',
        imagePath:LottieFiles.lgw2,
      ),
      const LegacyWrappedPageModel(
        title: '10,000 Words Typed with Meaning',
        description:
            'Every word you wrote added color to your story. That\'s a novel\'s worth of wisdom straight from the source.',
        richText:
            '',
        imagePath: LottieFiles.lgw3,
      ),
      const LegacyWrappedPageModel(
        title: '245 Minutes of Voice Wisdom',
        description:
            'Your words, spoken with heart, now echo through time. Future generations will hear your true voice.',
        richText:
            '',
        imagePath: LottieFiles.lgw4,
      ),

      const LegacyWrappedPageModel(
        title: '97 Minutes of Video Wisdom',
        description:
            'Your expressions. Your smile. Your voice. You\'ve made your legacy more vivid than ever.',
        richText:
            '',
        imagePath: LottieFiles.lgw5,
      ),

      const LegacyWrappedPageModel(
        title: 'Shared With 5 Family and Friends',
        description:
            'Legacy isn\'t built alone. You\'ve invited [X] people to begin their own journey too. You\'re planting trees in many hearts.',
        richText:
            '',
        imagePath: LottieFiles.lgw6,
      ),

      LegacyWrappedPageModel(
        title: 'You\'ve Unlocked Something Beautiful',
        description:
            'This is more than a summary it\'s a foundation. You\'ve planted the seeds of legacy, wisdom, and connection. Now, keep going your next story is waiting to be told.',
        richText:
            '',
        imagePath:"",
        data:[
          WData(title: "Preserve Your Wisdom",description: "Capture your life experiences, insights, and lessons learned for generations to come.",imagePath: Images.c1,progress: 10),
          WData(title: "Strengthen Family Bonds",description: "Bridge generational gaps by sharing your unique story and connecting loved ones.",imagePath: Images.c2,progress: 10),
          WData(title: "Gain Self-Understanding",description: "Reflect on your life's journey, clarify your values, and discover profound insights.",imagePath: Images.c3,progress: 10),
          WData(title: "Leave an Enduring Legacy",description: "Create a living, interactive archive of your life that will inspire and guide future generations.",imagePath: Images.c4,progress: 10),
          WData(title: "Inspire Your Loved Ones",description: "Share your resilience, triumphs, and wisdom to empower your family's future.",imagePath: Images.c5,progress: 10),
          WData(title: "Connect Across Generations",description: "Foster deeper connections with your 'Tribe' by giving them access to your stories and an interactive AI persona.",imagePath: Images.c6,progress: 10),
          WData(title: "Find Peace of Mind",description: "Rest assured that your memories and life lessons are securely preserved for eternity",imagePath: Images.c7,progress: 10),
        ],
        childListing: true
      ),
      //
      // const LegacyWrappedPageModel(
      //   title: 'You\'re Just Getting Started',
      //   description:
      //   'This is just one chapter. There are many more stories within you. Ready to capture your next memory?',
      //   richText:
      //   '',
      //   imagePath: Images.w8,
      // ),
    ];
  }


}


