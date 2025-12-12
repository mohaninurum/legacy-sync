import 'dart:io';

import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/home/data/model/home_journey_card_model.dart';
import 'package:legacy_sync/features/profile/data/model/edit_profile_pic_response.dart' show EditProfilePicResponse;
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import 'package:legacy_sync/features/profile/data/model/profile_model.dart';

abstract class FriendsProfileRepositories {

  ResultFuture<ProfileModel> getProfile(int userId);
  ResultFuture<ProfileModel> updateProfile(Map<String, dynamic> body);
  ResultFuture<EditProfilePicResponse> uploadProfileImage({required Map<String, String> body, required File imageFile});
  List<LegacySteps> getLegacySteps();
  ResultFuture<HomeJourneyCardModel> getHomeModule({required int userID});

}
