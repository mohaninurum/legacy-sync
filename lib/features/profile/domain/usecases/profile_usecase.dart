import 'dart:io';

import 'package:legacy_sync/features/profile/data/model/edit_profile_data_response_model.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_pic_response.dart';
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/model/profile_model.dart';
import '../../data/repositories/profile_repo_impl.dart';
import '../repositories/profile_repositories.dart';

class ProfileUseCase {
  final ProfileRepositories repository = ProfileRepoImpl();

  ResultFuture<ProfileModel> getProfile(int userId) async {
    return await repository.getProfile(userId);
  }

  ResultFuture<ProfileModel> updateProfile({required Map<String, dynamic> body}) async {
    return await repository.updateProfile(body);
  }

  ResultFuture<EditProfileDataResponseModel> editProfileDetail({required Map<String, dynamic> body}) async {
    return await repository.editProfileDetail(body);
  }

  ResultFuture<EditProfilePicResponse> uploadProfileImage({required Map<String, String> body, required File imageFile}) async {
    return await repository.uploadProfileImage(body: body, imageFile: imageFile);
  }

  Future<List<LegacySteps>> getLegacySteps(userId) {
    return repository.getLegacySteps(userId);
  }
}
