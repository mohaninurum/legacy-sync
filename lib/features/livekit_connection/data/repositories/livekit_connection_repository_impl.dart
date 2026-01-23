import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/invite_friend_response_model.dart';
import 'package:legacy_sync/features/livekit_connection/data/model/podcast_topics_model.dart';
import 'package:legacy_sync/features/livekit_connection/domain/repositories/livekit_connection_repository.dart';

class LiveKitConnectionRepositoryImpl extends LiveKitConnectionRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();
  static const String _sandboxId = 'legacy-audio-242zdl';

  @override
  ResultFuture<String> fetchParticipantToken({
    required String roomId,
    required String participantName,
  }) async {
    try {
      final res = await _apiServices.postSandboxApiResponse(
        ApiURL.liveKitApi,
        {
          "room_name": roomId,
          "participant_name": participantName,
        },
        sandboxId: _sandboxId,
      );

      return res.fold(
            (error) => Left(error),
            (data) {
          // data is jsonDecode(response.body)
          final token = (data as Map<String, dynamic>)['participantToken'];
          if (token is String && token.isNotEmpty) {
            return Right(token);
          }
          return const Left(FetchDataException("participantToken missing"));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }



  @override
  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId) async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.podcast_topic);
      return res.fold(
        (error) => Left(error),
        (data) => Right(PodcastTopicResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  // @override
  // ResultFuture<InviteFriendResponse> inviteFriendToPodcast({
  //   required int userId,
  //   required int friendId,
  //   required int podcastId,
  // }) async {
  //   try {
  //     final body = {
  //       "user_id": userId,
  //       "friend_id": friendId,
  //       "podcast_id": podcastId,
  //     };
  //
  //     final res = await _apiServices.getPostApiResponseNoAuth(
  //       ApiURL.inviteFriendToPodcast,
  //       body,
  //     );
  //
  //     // return res.fold(
  //     //       (error) => Left(error),
  //     //       (data) {
  //     //     // If your API returns {status:true,...} you can validate here.
  //     //     // Otherwise just treat 200/201 as success.
  //     //     return const Right(null);
  //     //   },
  //     // );
  //
  //     return res.fold(
  //           (error) => Left(error),
  //           (data) {
  //         final map = (data as Map<String, dynamic>);
  //         final parsed = InviteFriendResponse.fromJson(map);
  //
  //         if (parsed.status != true) {
  //           return Left(FetchDataException(parsed.message.isNotEmpty
  //               ? parsed.message
  //               : "Invite failed"));
  //         }
  //
  //         return Right(parsed);
  //       },
  //     );
  //
  //   } on AppException catch (e) {
  //     return Left(e);
  //   } catch (e) {
  //     return Left(FetchDataException(e.toString()));
  //   }
  // }

  @override
  ResultFuture<InviteFriendResponse> inviteFriendToPodcast({
    required int userId,
    required int friendId,
    required String roomId,
  }) async {
    try {
      final body = {
        "user_id": userId,
        "friend_id": friendId,
        "room_id": roomId,
      };

      final res = await _apiServices.getPostApiResponseNoAuth(
        ApiURL.inviteFriendToPodcast,
        body,
      );

      return res.fold(
            (error) => Left(error),
            (data) {
          if (data is! Map<String, dynamic>) {
            return const Left(FetchDataException("Invalid invite response"));
          }

          final parsed = InviteFriendResponse.fromJson(data);

          if (parsed.status != true) {
            return Left(
              FetchDataException(
                parsed.message.isNotEmpty ? parsed.message : "Invite failed",
              ),
            );
          }

          return Right(parsed);
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> startRecording({required int userId, required String roomId}) async {
    try {
      final body = {
        "user_id": userId,
        "room_id": roomId,
      };

      final res = await _apiServices.getPostApiResponseNoAuth(
        ApiURL.record_start,
        body,
      );

      return res.fold(
            (error) => Left(error),
            (data) {
          if (data is Map<String, dynamic>) return Right(data);
          return const Left(FetchDataException("Invalid start recording response"));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> stopRecording({
    required String roomId,
  }) async {
    try {
      final body = {"room_id": roomId};

      final res = await _apiServices.getPostApiResponseNoAuth(
        ApiURL.record_stop,
        body,
      );

      return res.fold(
            (error) => Left(error),
            (data) {
          if (data is Map<String, dynamic>) return Right(data);
          return const Left(FetchDataException("Invalid stop recording response"));
        },
      );
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

}
