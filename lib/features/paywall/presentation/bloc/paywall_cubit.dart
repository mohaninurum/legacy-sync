import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/features/paywall/data/repositories/paywall_repository_impl.dart';
import 'package:legacy_sync/features/paywall/domain/usecases/get_paywall_pages.dart';
import 'package:legacy_sync/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit() : super(const PaywallState());

  void loadPages() {

    final repo = PaywallRepositoryImpl();
    final usecase = GetPaywallPagesUseCase(repo);
    final pages = usecase(AppService.userFirstName);
  }
}
