
import '../../../../config/network/network_api_service.dart';
import '../../data/listening_podcast_list_model.dart';
import '../../data/my_favorite_podcast_model.dart';
import '../../data/podcast_model.dart';
import '../../data/recent_user_model.dart';

abstract class MyPodcastRepositories {
  ResultFuture<PodcastResponse> getMyPodcast(int userId);
  ResultFuture<ContinueListeningPodcastResponse> getContinueListeningList(int userId);
  ResultFuture<RecentPodcastResponse> getRecentFriendList(int userId);
  ResultFuture<FavouritePodcastResponse> getFavouritePodcastList(int userId);
}
