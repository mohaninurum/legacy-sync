import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:legacy_sync/features/podcast/domain/repositories/podcast_repositories.dart';

import '../../../../config/db/shared_preferences.dart';
import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../../../config/network/network_api_service.dart';
import '../../../answer/domain/repositories/answer_repository.dart';
import '../model/token_room_model.dart';

class PodcastRepoImpl implements PodcastRepositories {

  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<TokenRoomModel>  fetchLiveKitToken() async {
     var useName = AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    try {
      Map<String, String> data = {
        "purpose" :"call",
        "participantName":"$useName"
      };

      final result = await _apiServices.getPostApiResponse(ApiURL.livekit_generate_channel, data);

      return result.fold((error) => Left(AppException(error.message)), (data) => Right(TokenRoomModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(AppException(e.message));
    } catch (e) {
      return Left(AppException(e.toString()));
    }

    // final response = await http.post(
    //   Uri.parse('https://cloud-api.livekit.io/api/sandbox/connection-details'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'X-Sandbox-ID': 'legacy-audio-242zdl',
    //   },
    //   body: jsonEncode({
    //     'room_name': 'test-audio-room',
    //     'participant_name': 'flutter_user',
    //   }),
    // );
    //
    //  print("response:: ${response.body}");
    //
    // return jsonDecode(response.body);

  }


}