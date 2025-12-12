import 'package:legacy_sync/features/post_paywall/data/model/post_paywall_page.dart';
import 'package:legacy_sync/features/post_paywall/domain/repositories/post_paywall_repository.dart';

class GetPostPaywallPagesUseCase {
  final PostPaywallRepository repository;
  GetPostPaywallPagesUseCase(this.repository);

  List<PostPaywallPageModel> call() => repository.getPostPaywallPages();
}
