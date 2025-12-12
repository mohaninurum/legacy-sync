import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';
import 'package:legacy_sync/features/card/domain/repositories/card_repository.dart';

class UpdateCardGradientUseCase {
  final CardRepository repository;

  UpdateCardGradientUseCase(this.repository);

  ResultFuture<CardModel> call(int gradientIndex) {
    return repository.updateCardGradient(gradientIndex);
  }
}
