import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/add_fav_que_model.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/remove_fav_que_model.dart';
import 'package:legacy_sync/features/favorite_memories/domain/repositories/favorite_memories_repository.dart';

class FavoriteMemoriesRepositoryImpl implements FavoriteMemoriesRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<AddFavQueModel> addFavQuestion(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(
        ApiURL.ADD_FAV_QUESTION,
        body,
      );
      return res.fold(
            (error) => Left(error),
            (data) => Right(AddFavQueModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<RemoveFavQueModel> removeFavQuestion(
      Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(
          ApiURL.REMOVE_FAV_QUESTION, body);
      return res.fold((error) => Left(error), (data) =>
          Right(RemoveFavQueModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<ListOfFavQueModelData> getListOfFavQuestion(int userID) async {
    try {
      final res = await _apiServices.getGetApiResponse(
          "${ApiURL.GET_FAV_QUESTIONS}$userID");
      return res.fold((error) => Left(error), (data) =>
          Right(ListOfFavQueModelData.fromJson(data)),);
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
