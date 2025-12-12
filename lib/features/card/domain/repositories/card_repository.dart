import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';
import 'package:legacy_sync/features/card/data/model/updated_card_details.dart';

abstract class CardRepository {
  ResultFuture<CardModel> getCard();
  ResultFuture<CardModel> updateCardGradient(int gradientIndex);
  ResultFuture<List<GradientOption>> getGradientOptions();
  ResultFuture<UpdatedCardDetails> getCardDetails({required int userID});

}
