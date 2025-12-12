

import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/repositories/friends_profile_repo_impl.dart';
import '../repositories/friends_profile_repositories.dart';

class FriendsProfileUseCase {
  final FriendsProfileRepositories repository = FriendsProfileRepoImpl();


  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userId}) async {
    return await repository.getHomeModule(userID: userId);
  }

  ResultFuture<HomeJourneyCardModel> getChatModule({required int userId}) async {
    return await repository.getHomeModule(userID: userId);
  }
}
