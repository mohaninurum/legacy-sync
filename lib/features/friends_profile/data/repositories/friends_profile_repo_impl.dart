import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/friends_profile/domain/repositories/friends_profile_repositories.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_pic_response.dart';
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import 'package:legacy_sync/features/profile/data/model/profile_model.dart';
import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';

class FriendsProfileRepoImpl extends FriendsProfileRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();
  @override
  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userID}) async{
    try {
      final res = await _apiServices.getGetApiResponse("${ApiURL.GET_LEGACY_HOME_MODULE}$userID");
      return res.fold((error) => Left(error), (data) => Right(HomeJourneyCardModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }
  @override
  ResultFuture<ProfileModel> getProfile(int userId) async {
    try {
      final res = await _apiServices.getGetApiResponse("${ApiURL.get_profile}$userId");
      return res.fold((error) => Left(error), (data) => Right(ProfileModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<ProfileModel> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.update_profile, body);
      return res.fold((error) => Left(error), (data) => Right(ProfileModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  List<LegacySteps> getLegacySteps() {
    List<LegacySteps> data = [];
    data = [
      LegacySteps(title: "Preserve Your Wisdom", description: "Capture your life experiences, insights, and lessons learned for generations to come.", imagePath: Images.c1, progress: 10),
      LegacySteps(title: "Strengthen Family Bonds", description: "Bridge generational gaps by sharing your unique story and connecting loved ones.", imagePath: Images.c2, progress: 10),
      LegacySteps(title: "Gain Self-Understanding", description: "Reflect on your life's journey, clarify your values, and discover profound insights.", imagePath: Images.c3, progress: 10),
      LegacySteps(
        title: "Leave an Enduring Legacy",
        description: "Create a living, interactive archive of your life that will inspire and guide future generations.",
        imagePath: Images.c4,
        progress: 10,
      ),
      LegacySteps(title: "Inspire Your Loved Ones", description: "Share your resilience, triumphs, and wisdom to empower your family's future.", imagePath: Images.c5, progress: 10),
      LegacySteps(
        title: "Connect Across Generations",
        description: "Foster deeper connections with your 'Tribe' by giving them access to your stories and an interactive AI persona.",
        imagePath: Images.c6,
        progress: 10,
      ),
      LegacySteps(title: "Find Peace of Mind", description: "Rest assured that your memories and life lessons are securely preserved for eternity", imagePath: Images.c7, progress: 10),
    ];

    return data;
  }

  @override
  ResultFuture<EditProfilePicResponse> uploadProfileImage({required Map<String, String> body, required File imageFile}) async {
    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}${imageFile.path.split('/').last}";
      Uint8List fileBytes = await imageFile.readAsBytes();
      final result = await _apiServices.getPostUploadMultiPartApiResponse(ApiURL.EDIT_PROFILE_PICTURE, body, fileBytes, fileName, "image", "PUT");
      return result.fold((error) => Left(AppException(error.message)), (data) => Right(EditProfilePicResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(AppException(e.toString()));
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }


}
