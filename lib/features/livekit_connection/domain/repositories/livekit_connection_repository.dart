import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/invite_friend_response_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';

abstract class LiveKitConnectionRepositories {
  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId);
  ResultFuture<String> fetchParticipantToken({required String roomId, required String participantName,});
  ResultFuture<InviteFriendResponse> inviteFriendToPodcast({required int userId, required int friendId, required String roomId,});
  ResultFuture<Map<String,dynamic>> startRecording({required int userId, required String roomId});
  ResultFuture<Map<String,dynamic>> stopRecording({required String roomId});
}