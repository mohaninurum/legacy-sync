
import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';

import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';

import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../domain/repositories/podcast_recording_repositores.dart';
import '../podcast_topic/podcast_topics_model.dart';


class PodcastRecordingRepoImpl extends PodcastRecordingRepositores {

  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId) async {
    try {
      final res = await _apiServices.getGetApiResponse(
        ApiURL.podcast_topic,
      );
      return res.fold(
            (error) => Left(error),
            (data) => Right(PodcastTopicResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

}