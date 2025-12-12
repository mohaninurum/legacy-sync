import 'package:legacy_sync/features/paywall/data/model/paywall_page.dart';
import 'package:legacy_sync/features/paywall/domain/repositories/paywall_repository.dart';

class GetPaywallPagesUseCase {
  final PaywallRepository repository;
  GetPaywallPagesUseCase(this.repository);

  List<PaywallPageModel> call(String userName) => repository.getPaywallPages(userName);
}
