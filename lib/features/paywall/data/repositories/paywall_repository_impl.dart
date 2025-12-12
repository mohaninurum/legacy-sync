import 'package:legacy_sync/features/paywall/data/model/paywall_page.dart';
import 'package:legacy_sync/features/paywall/domain/repositories/paywall_repository.dart';
import 'package:legacy_sync/core/images/images.dart';

import '../../../../config/db/shared_preferences.dart';

class PaywallRepositoryImpl implements PaywallRepository {
  @override
  List<PaywallPageModel> getPaywallPages(String userName) {
    return  [
      PaywallPageModel(
        title: 'Congratulations, $userName! you are now a Legacy Creator!',
        description:
            "You've taken the first courageous step towards preserving your timeless story.",
        imagePath: Images.post1,
      ),
      const PaywallPageModel(
        title: 'Every Memory, A Step Forward.',
        description:
            'Your unique story will unfold with each treasured moment you capture.',
        imagePath: Images.post2,
      ),
      const PaywallPageModel(
        title: 'Sometimes Stories\nFlow Effortlessly...',
        description:
            'You all find memories surface with ease, like gentle rivers finding their way.',
        imagePath: Images.post3,
      ),
      const PaywallPageModel(
        title: '...and sometimes\nthey invite reflection.',
        description:
            'Some moments call for a thoughtful pause, a deeper look, or quiet contemplation to uncover their true essence.',
        imagePath: Images.post4,
      ),
      const PaywallPageModel(
        title: 'This is the Start of\nYour Living Legacy.',
        description:
            'Whether a whispered anecdote or a grand tale, your authentic voice is the heart of your priceless story.',
        imagePath: Images.post5,
      ),
      const PaywallPageModel(
        title: 'We all Guide Every Chapter.',
        description:
            'Your personalized prompts, intuitive tools, and AI companion are here to support you at every turn, making legacy creation truly accessible.',
        imagePath: Images.post6,
      ),

      const PaywallPageModel(
        title: 'We qre Proud of the\nLegacy You are Building.',
        description:
            'Each story added is a priceless gift, enriching your family\'s future and cementing your place in their history.',
        imagePath: Images.post7,
      ),

      const PaywallPageModel(
        title:
            'Your Story is Ready to Unfold. Whenever you need us, we are right here!',
        description:
            'Whenever you\'re ready to share, we\'re here to help you capture and cherish your irreplaceable wisdom.',
        imagePath: Images.post8,
      ),
    ];
  }
}
