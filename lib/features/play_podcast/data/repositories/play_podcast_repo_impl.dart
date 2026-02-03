import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';

import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../domain/repositories/repositories_play_podcast.dart';

class PlayPodcastRepoImpl extends RepositoriesPlayPodcast {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<Map<String, dynamic>> saveListenedPodcastTime(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _apiServices.getPostApiResponse(
        ApiURL.podcast_Save_Listened_PodcastTime,
        body,
      );
      return res.fold((error) => Left(error), (data) => Right(data));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<MarkFavouriteResponse> markFavouritePodcast(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _apiServices.getPostApiResponse(
        ApiURL.mark_podcast_favourite,
        body,
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(MarkFavouriteResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<MarkUnFavouriteResponse> markUnFavouritePodcast(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _apiServices.getPostApiResponse(
        ApiURL.mark_podcast_un_favourite,
        body,
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(MarkUnFavouriteResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
