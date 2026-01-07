import 'package:dartz/dartz.dart';

import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/network_api_service.dart';

import '../../data/podcast_topic/podcast_topics_model.dart';

abstract class PodcastRecordingRepositores {
  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId);


}
