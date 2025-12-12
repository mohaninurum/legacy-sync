import 'package:legacy_sync/config/network/network_api_service.dart' show ResultFuture;
import 'package:legacy_sync/features/home/data/model/add_friend_response_model.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';
import 'package:legacy_sync/features/home/data/repositories/home_repo_impl.dart';
import 'package:legacy_sync/features/home/domain/repositories/home_repo.dart';

class HomeUseCases{
  final HomeRepo repository = HomeRepoImpl();
  ResultFuture<FriendsListModel> getFriendsList({required int userId}) async {
    return await repository.getFriendsList(userId:userId);
  }

  ResultFuture<AddFriendResponseModel> addFriend({required Map<String,dynamic> body}) async {
    return await repository.addFriend(body:body);
  }

  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userId}) async {
    return await repository.getHomeModule(userID: userId);
  }


}