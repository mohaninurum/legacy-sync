import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_data_response_model.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_pic_response.dart';
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import 'package:legacy_sync/features/profile/data/model/profile_model.dart';
import 'package:legacy_sync/features/profile/domain/repositories/profile_repositories.dart';
import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../../../core/images/lottie.dart';

class ProfileRepoImpl extends ProfileRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<ProfileModel> getProfile(int userId) async {
    try {
      final res = await _apiServices.getGetApiResponse(
        "${ApiURL.get_profile}$userId",
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(ProfileModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<ProfileModel> updateProfile(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(
        ApiURL.update_profile,
        body,
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(ProfileModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<EditProfileDataResponseModel> editProfileDetail(
    Map<String, dynamic> body,
  ) async {
    try {
      final res = await _apiServices.getPutApiResponse(
        ApiURL.EDIT_PROFILE,
        body,
      );
      return res.fold(
        (error) => Left(error),
        (data) => Right(EditProfileDataResponseModel.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<List<LegacySteps>> getLegacySteps(userId) async {
    List<LegacySteps> data = [];
    // data = [
    //   LegacySteps(title: "Preserve Your Wisdom", description: "Capture your life experiences, insights, and lessons learned for generations to come.", imagePath: Images.c1, progress: 10),
    //   LegacySteps(title: "Strengthen Family Bonds", description: "Bridge generational gaps by sharing your unique story and connecting loved ones.", imagePath: Images.c2, progress: 10),
    //   LegacySteps(title: "Gain Self-Understanding", description: "Reflect on your life's journey, clarify your values, and discover profound insights.", imagePath: Images.c3, progress: 10),
    //   LegacySteps(
    //     title: "Leave an Enduring Legacy",
    //     description: "Create a living, interactive archive of your life that will inspire and guide future generations.",
    //     imagePath: Images.c4,
    //     progress: 10,
    //   ),
    //   LegacySteps(title: "Inspire Your Loved Ones", description: "Share your resilience, triumphs, and wisdom to empower your family's future.", imagePath: Images.c5, progress: 10),
    //   LegacySteps(
    //     title: "Connect Across Generations",
    //     description: "Foster deeper connections with your 'Tribe' by giving them access to your stories and an interactive AI persona.",
    //     imagePath: Images.c6,
    //     progress: 10,
    //   ),
    //   LegacySteps(title: "Find Peace of Mind", description: "Rest assured that your memories and life lessons are securely preserved for eternity", imagePath: Images.c7, progress: 10),
    // ];

    // try {
    //   final res = await _apiServices.getGetApiResponse("${ApiURL.module_list}$userId");
    //   res.fold((error) => Left(error), (data){
    //     for (var element in data) {
    //       data.add(LegacySteps(title: element['module_title'], description: element['module_description'], imagePath: Images.c7, progress: element['progress']));
    //   }
    //   });
    //
    //   return data;
    // } on AppException catch (e) {
    //   Left(e);
    // }
    try {
      final res = await _apiServices.getGetApiResponse(
        "${ApiURL.module_list}$userId",
      );

      return res.fold(
        (error) {
          return data; // empty list if error
        },
        (result) {
          // result is Map<String, dynamic>
          final list = result["data"] as List<dynamic>? ?? [];
          List<String> image = [
            "assets/images/1.png",
            "assets/images/2.png",
            "assets/images/3.png",
            "assets/images/4.png",
            "assets/images/5.png",
            "assets/images/6.png",
            "assets/images/7.png",
            "assets/images/8.png",
          ];
          List lottieImage = [
            LottieFiles.module_header,
            LottieFiles.module_header2,
            LottieFiles.module_header3,
            LottieFiles.module_header4,
            LottieFiles.module_header5,
            LottieFiles.module_header6,
            LottieFiles.module_header7,
            LottieFiles.module_header8,
          ];

          List<String> imageName = [
            'm1iconfile',
            'm2iconfile',
            'm3iconfile',
            'm4iconfile',
            'm5iconfile',
            'm6iconfile',
            'm7iconfile',
            'm8iconfile',
          ];

          for (var element in list) {
            String apiKey = element['icon_file_code'] ?? "";

            // find index
            int index = imageName.indexOf(apiKey);

            // fallback if not found
            String moduleImagePath = index != -1 ? lottieImage[index] : lottieImage[0];

            data.add(
              LegacySteps(
                title: element['module_title'] ?? "",
                description: element['module_description'] ?? "",
                imagePath: moduleImagePath,
                progress: element['progress'] ?? 0,
              ),
            );
          }

          return data;
        },
      );
    } on AppException {
      return data;
    }
  }

  @override
  ResultFuture<EditProfilePicResponse> uploadProfileImage({
    required Map<String, String> body,
    required File imageFile,
  }) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}${imageFile.path.split('/').last}";
      Uint8List fileBytes = await imageFile.readAsBytes();
      final result = await _apiServices.getPostUploadMultiPartApiResponse(
        ApiURL.EDIT_PROFILE_PICTURE,
        body,
        fileBytes,
        fileName,
        "image",
        "PUT",
      );
      return result.fold(
        (error) => Left(AppException(error.message)),
        (data) => Right(EditProfilePicResponse.fromJson(data)),
      );
    } on AppException catch (e) {
      return Left(AppException(e.toString()));
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }
}
