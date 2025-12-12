import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/post_paywall/data/model/post_paywall_page.dart';
import 'package:legacy_sync/features/post_paywall/domain/repositories/post_paywall_repository.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class PostPaywallRepositoryImpl implements PostPaywallRepository {
  @override
  List<PostPaywallPageModel> getPostPaywallPages() {
    return [
      PostPaywallPageModel(
        title: 'Congratulations, ${AppService.userFirstName}! you are now a Legacy Creator!',
        description: "You've taken the first courageous step towards preserving your timeless story.",
        imagePath: LottieFiles.post1,
      ),
      const PostPaywallPageModel(title: 'Every Memory, A Step Forward.', description: 'Your unique story will unfold with each treasured moment you capture.', imagePath: LottieFiles.post2),
      const PostPaywallPageModel(
        title: 'Sometimes Stories\nFlow Effortlessly...',
        description: 'You all find memories surface with ease, like gentle rivers finding their way.',
        imagePath: LottieFiles.post3,
      ),
      const PostPaywallPageModel(
        title: '...and sometimes\nthey invite reflection.',
        description: 'Some moments call for a thoughtful pause, a deeper look, or quiet contemplation to uncover their true essence.',
        imagePath: LottieFiles.post4,
      ),
      const PostPaywallPageModel(
        title: 'This is the Start of\nYour Living Legacy.',
        description: 'Whether a whispered anecdote or a grand tale, your authentic voice is the heart of your priceless story.',
        imagePath: LottieFiles.post5,
      ),
      const PostPaywallPageModel(
        title: 'We all Guide Every Chapter.',
        description: 'Your personalized prompts, intuitive tools, and AI companion are here to support you at every turn, making legacy creation truly accessible.',
        imagePath: LottieFiles.post6,
      ),

      const PostPaywallPageModel(
        title: 'We qre Proud of the\nLegacy You are Building.',
        description: 'Each story added is a priceless gift, enriching your family\'s future and cementing your place in their history.',
        imagePath: Images.post7,
      ),

      const PostPaywallPageModel(
        title: 'Your Story is Ready to Unfold. Whenever you need us, we are right here!',
        description: 'Whenever you\'re ready to share, we\'re here to help you capture and cherish your irreplaceable wisdom.',
        imagePath: LottieFiles.post8,
      ),
    ];
  }
}
