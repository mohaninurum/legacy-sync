import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/invite_friend_response_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/repositories/livekit_connection_repository_impl.dart';
import 'package:legacy_sync/features/livekit_connection/domain/repositories/livekit_connection_repository.dart';

class LiveKitConnectionUseCases {
  final LiveKitConnectionRepositories repository =
      LiveKitConnectionRepositoryImpl();

  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId) async {
    return await repository.getPodcastTopic(userId);
  }

  ResultFuture<String> fetchParticipantToken({
    required String roomId,
    required String participantName,
  }) async {
    return repository.fetchParticipantToken(
      roomId: roomId,
      participantName: participantName,
    );
  }

  ResultFuture<InviteFriendResponse> inviteFriendToPodcast({
    required int userId,
    required int friendId,
    required String roomId,
  }) async {
    return repository.inviteFriendToPodcast(
      userId: userId,
      friendId: friendId,
      roomId: roomId,
    );
  }

  ResultFuture<Map<String, dynamic>> startRecording({
    required int userId,
    required String roomId,
  }) async {
    return repository.startRecording(userId: userId, roomId: roomId);
  }

  ResultFuture<Map<String,dynamic>> stopRecording({
    required String roomId,
}) async {
    return repository.stopRecording(roomId: roomId);
  }
}
