import '../../../../config/network/network_api_service.dart';
import '../../data/model/token_room_model.dart';

abstract class PodcastRepositories {
  ResultFuture<TokenRoomModel>  fetchLiveKitToken();

}
