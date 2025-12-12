import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/home/data/model/add_friend_response_model.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';
import 'package:legacy_sync/features/home/domain/repositories/home_repo.dart';

class HomeRepoImpl extends HomeRepo{
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<FriendsListModel> getFriendsList({required int userId}) async{
    try {
      final res = await _apiServices.getGetApiResponse("${ApiURL.GET_FRIEND_LIST}$userId");
      return res.fold((error) => Left(error), (data) => Right(FriendsListModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<AddFriendResponseModel> addFriend({required Map<String, dynamic> body}) async{
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.ADD_NEW_FRIEND,body);
      return res.fold((error) => Left(error), (data) => Right(AddFriendResponseModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userID}) async{
    try {
      final res = await _apiServices.getGetApiResponse("${ApiURL.GET_LEGACY_HOME_MODULE}$userID");
      return res.fold((error) => Left(error), (data) => Right(HomeJourneyCardModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }



}