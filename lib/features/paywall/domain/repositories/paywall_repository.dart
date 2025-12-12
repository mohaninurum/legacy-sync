import 'package:legacy_sync/features/paywall/data/model/paywall_page.dart';

abstract class PaywallRepository {
  List<PaywallPageModel> getPaywallPages(String userName);
}
