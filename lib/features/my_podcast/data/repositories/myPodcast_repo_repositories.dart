
import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';

import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';

import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../domain/repositories/my_podcast_repositories.dart';
import '../listening_podcast_list_model.dart';
import '../my_favorite_podcast_model.dart';
import '../recent_user_model.dart';

class MyPodcastRepoRepositoriesRepoImpl extends MyPodcastRepositories {

  static final BaseApiServices _apiServices = NetworkApiService();


  @override
  ResultFuture<PodcastResponse> getMyPodcast(int userId) async {

    try {
     final res = await _apiServices.getGetApiResponse(
       "${ApiURL.my_podcast}$userId",
     );
     return res.fold(
           (error) => Left(error),
           (data) => Right(PodcastResponse.fromJson(data)),
     );
   } on AppException catch (e) {
     return Left(e);
   }
  }


  @override
  ResultFuture<ContinueListeningPodcastResponse> getContinueListeningList(int userId) async {

    try {
     final res = await _apiServices.getGetApiResponse(
       "${ApiURL.podcast__Listened_list}$userId",
     );
     return res.fold(
           (error) => Left(error),
           (data) => Right(ContinueListeningPodcastResponse.fromJson(data)),
     );
   } on AppException catch (e) {
     return Left(e);
   }
  }


  @override
  ResultFuture<RecentPodcastResponse> getRecentFriendList(int userId) async {

    try {
     final res = await _apiServices.getGetApiResponse(
       "${ApiURL.recent_podcast_friend_list}$userId",
     );
     return res.fold(
           (error) => Left(error),
           (data) => Right(RecentPodcastResponse.fromJson(data)),
     );
   } on AppException catch (e) {
     return Left(e);
   }
  }


  @override
  ResultFuture<FavouritePodcastResponse> getFavouritePodcastList(int userId) async {

    try {
     final res = await _apiServices.getGetApiResponse(
       "${ApiURL.favourite_podcast_list}$userId",
     );
     return res.fold(
           (error) => Left(error),
           (data) => Right(FavouritePodcastResponse.fromJson(data)),
     );
   } on AppException catch (e) {
     return Left(e);
   }
  }


}