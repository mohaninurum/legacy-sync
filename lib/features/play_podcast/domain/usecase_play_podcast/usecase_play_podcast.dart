import 'package:dartz/dartz.dart';

import 'package:legacy_sync/config/network/app_exceptions.dart';

import 'package:legacy_sync/features/podcast_recording/data/podcast_topic/podcast_topics_model.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/repositories/play_podcast_repo_impl.dart';


class UsecasePlayPodcast {
  final PlayPodcastRepoImpl repository = PlayPodcastRepoImpl();

  ResultFuture<Map<String,dynamic>> saveListenedPodcastTime(Map<String, dynamic> body) async {
    return await repository.saveListenedPodcastTime(body);
  }


}
