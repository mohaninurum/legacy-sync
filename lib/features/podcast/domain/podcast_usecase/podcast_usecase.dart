import '../../../../config/network/network_api_service.dart';
import '../../data/model/token_room_model.dart';
import '../../data/repositories/podcast_repo_impl.dart';
import '../repositories/podcast_repositories.dart';

class PodcastUsecase extends PodcastRepositories {
  final PodcastRepoImpl repository = PodcastRepoImpl();
  @override
  ResultFuture<TokenRoomModel>  fetchLiveKitToken(){
    return repository.fetchLiveKitToken();
  }
}