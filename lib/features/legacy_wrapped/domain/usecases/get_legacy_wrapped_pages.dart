import 'package:legacy_sync/features/legacy_wrapped/data/model/legacy_wrapped_page.dart';
import 'package:legacy_sync/features/legacy_wrapped/domain/repositories/legacy_wrapped_repository.dart';

class GetLegacyWrappedPagesUseCase {
  final LegacyWrappedRepository repository;
  GetLegacyWrappedPagesUseCase(this.repository);

  List<LegacyWrappedPageModel> call() => repository.getLegacyWrappedPages();
}
