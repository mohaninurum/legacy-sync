import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';
import 'package:legacy_sync/features/card/data/model/updated_card_details.dart';
import 'package:legacy_sync/features/card/domain/repositories/card_repository.dart';

class GetCardUseCase {
  final CardRepository repository;

  GetCardUseCase(this.repository);

  ResultFuture<CardModel> call() {
    return repository.getCard();
  }

  ResultFuture<UpdatedCardDetails> getCardDetails({required int userId}) async {
    return await repository.getCardDetails(userID: userId);
  }
}
