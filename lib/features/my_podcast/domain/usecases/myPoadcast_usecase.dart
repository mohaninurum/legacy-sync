import 'package:legacy_sync/features/my_podcast/domain/repositories/my_podcast_repositories.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/podcast_model.dart';
import '../../data/repositories/myPodcast_repo_repositories.dart';

class MyPoadastUsecase {
  final MyPodcastRepositories repository = MyPodcastRepoRepositoriesRepoImpl();

  ResultFuture<PodcastResponse> getMyPodcast(int userId) async {
    return await repository.getMyPodcast(userId);
  }


}
