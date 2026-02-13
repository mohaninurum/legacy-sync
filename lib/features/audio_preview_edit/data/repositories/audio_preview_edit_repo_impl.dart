import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/publish_response.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/save_as_draft.dart';
import 'package:legacy_sync/features/audio_preview_edit/domain/repositories/audio_preview_edit_repositories.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

class AudioPreviewEditRepoImpl extends AudioPreviewEditRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<SaveAsDraft> saveAsDraftMultipart({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,
  }) async {
    try {
      final res = await _apiServices.getPostUploadMultiPartApiResponse(
        ApiURL.savePodcast_AsDraft,
        fields,
        thumbnailBytes,
        thumbnailFileName,
        thumbnailKey,
        "POST",
      );

      return res.fold(
            (error) => Left(error),
            (data) => Right(SaveAsDraft.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<PublishResponse> publishPodcast({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,}) async {
    try {
      final res = await _apiServices.getPostUploadMultiPartApiResponse(
          ApiURL.postPodcast,
        fields,
        thumbnailBytes,
        thumbnailFileName,
        thumbnailKey,
        "POST",
      );

      return res.fold(
            (error) => Left(error),
            (data) => Right(PublishResponse.fromJson(data as Map<String, dynamic>)),
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
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
