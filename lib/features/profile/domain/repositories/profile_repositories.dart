import 'dart:io';

import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_data_response_model.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_pic_response.dart' show EditProfilePicResponse;
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import '../../data/model/profile_model.dart';

abstract class ProfileRepositories {
  ResultFuture<ProfileModel> getProfile(int userId);
  ResultFuture<ProfileModel> updateProfile(Map<String, dynamic> body);
  ResultFuture<EditProfileDataResponseModel> editProfileDetail(Map<String, dynamic> body);
  ResultFuture<EditProfilePicResponse> uploadProfileImage({required Map<String, String> body, required File imageFile});
  Future<List<LegacySteps>> getLegacySteps(userId);
}
