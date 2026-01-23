import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/create_new_podcast/data/model/create_new_podcast_model.dart';
import 'package:legacy_sync/features/create_new_podcast/domain/repositories/create_new_podcast_repositories.dart';

class CreateNewPodcastRepoImpl extends CreateNewPodcastRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<CreateNewPodcastModel> createNewPodcast({
    required Map<String, dynamic> body,
    required File thumbnail,
  }) async {
    try {
      /// Convert body to Map<String, String>
      final Map<String, String> fields = body.map(
            (key, value) => MapEntry(key, value.toString()),
      );

      final bytes = await thumbnail.readAsBytes();

      final res = await _apiServices.getPostUploadMultiPartApiResponse(
        ApiURL.create_new_podcast,
        fields,
        bytes,
        thumbnail.path.split('/').last,
        "thumb_nail",
        "POST",
      );

      return res.fold(
            (error) => Left(error),
            (data) => Right(CreateNewPodcastModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }
}