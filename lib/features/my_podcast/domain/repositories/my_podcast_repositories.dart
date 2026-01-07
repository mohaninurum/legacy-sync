import 'package:dartz/dartz.dart';

import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/network_api_service.dart';
import '../../data/podcast_model.dart';

abstract class MyPodcastRepositories {
  ResultFuture<PodcastResponse> getMyPodcast(int userId);


}
