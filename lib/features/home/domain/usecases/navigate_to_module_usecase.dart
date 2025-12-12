import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';

class NavigateToModuleUsecase {
  static Map<String, dynamic> execute(JourneyCardModel card) {
    return {
      'moduleId': card.id,
      'moduleTitle': card.title,
      'moduleImage': card.imagePath,
    };
  }
}
