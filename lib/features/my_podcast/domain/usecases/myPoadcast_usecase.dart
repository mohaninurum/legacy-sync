import 'package:legacy_sync/features/my_podcast/domain/repositories/my_podcast_repositories.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/listening_podcast_list_model.dart';
import '../../data/my_favorite_podcast_model.dart';
import '../../data/podcast_model.dart';
import '../../data/recent_user_model.dart';
import '../../data/repositories/myPodcast_repo_repositories.dart';

class MyPoadastUsecase {
  final MyPodcastRepositories repository = MyPodcastRepoRepositoriesRepoImpl();

  ResultFuture<PodcastResponse> getMyPodcast(int userId) async {
    return await repository.getMyPodcast(userId);
  }

  ResultFuture<ContinueListeningPodcastResponse> getContinueListeningList(int userId) async {
    return await repository.getContinueListeningList(userId);
  }

 ResultFuture<RecentPodcastResponse> getRecentFriendList(int userId) async {
    return await repository.getRecentFriendList(userId);
  }
  ResultFuture<FavouritePodcastResponse> getFavouritePodcastList(int userId) async {
    return await repository.getFavouritePodcastList(userId);
  }


}
