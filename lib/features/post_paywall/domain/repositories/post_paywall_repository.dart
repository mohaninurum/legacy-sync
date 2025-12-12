import 'package:legacy_sync/features/post_paywall/data/model/post_paywall_page.dart';

abstract class PostPaywallRepository {
  List<PostPaywallPageModel> getPostPaywallPages();
}
