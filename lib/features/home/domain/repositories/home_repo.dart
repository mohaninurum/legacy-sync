import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/home/data/model/add_friend_response_model.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';

abstract class HomeRepo {
  ResultFuture<FriendsListModel> getFriendsList({required int userId});
  ResultFuture<AddFriendResponseModel> addFriend({required Map<String,dynamic> body});
  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userID});
}
