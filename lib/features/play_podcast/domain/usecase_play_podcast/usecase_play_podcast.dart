import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/repositories/play_podcast_repo_impl.dart';


class UseCasePlayPodcast {
  final PlayPodcastRepoImpl repository = PlayPodcastRepoImpl();

  ResultFuture<Map<String,dynamic>> saveListenedPodcastTime(Map<String, dynamic> body) async {
    return await repository.saveListenedPodcastTime(body);
  }

  ResultFuture<MarkFavouriteResponse> markFavouritePodcast(Map<String, dynamic> body) async {
    return await repository.markFavouritePodcast(body);
  }

  ResultFuture<MarkUnFavouriteResponse> markUnFavouritePodcast(Map<String, dynamic> body) async {
    return await repository.markUnFavouritePodcast(body);
  }
}
