import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/usecases/profile_usecase.dart';
import '../profile_state/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase _profileUseCase = ProfileUseCase();

  ProfileCubit() : super(const ProfileState());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();




  void getLegacySteps() async{
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final mResult = await _profileUseCase.getLegacySteps(userId);
    emit(state.copyWith(steps:  mResult));

  }

  Future<void> loadProfile(BuildContext context, {bool loadForce = false}) async {
    final isSocial = await AppPreference().getInt(key: AppPreference.KEY_LOGIN_TYPE_IS_SOCIAL);
    final socialLoginProvider = await AppPreference().getInt(key: AppPreference.KEY_SOCIAL_LOGIN_PROVIDER);

    if (isSocial == 0 && socialLoginProvider == 2) {
      emit(state.copyWith(isLoginByApple: true));
    }

    try {
      Utils.showLoader();
      emit(state.copyWith(isLoading: true));
      if (!loadForce) {
        if (state.profileData != null) {
          emit(state.copyWith(profileData: state.profileData, isLoading: false, error: null));
          Utils.closeLoader();
          return;
        }
      }
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      final mResult = await _profileUseCase.getProfile(userId);

      mResult.fold(
        (error) {
          print("APP EXCEPTION:: ${error.message}");
          Utils.closeLoader();
          emit(state.copyWith(isLoading: false, error: error.message));
        },
        (result) {
          Utils.closeLoader();
          if (result.data != null) {
            print("DATA ON SUCCESS:: ${result.data}");

            emit(state.copyWith(profileData: result.data!, isLoading: false, error: null));
            firstNameController.text = state.profileData!.firstName ?? '';
            lastNameController.text = state.profileData!.lastName ?? '';
            emailController.text = state.profileData!.email ?? '';
            dobController.text = formatDate(state.profileData!.dateOfBirth ?? '');
            AppPreference().set(key: AppPreference.KEY_USER_FIRST_NAME, value: firstNameController.text);
            AppPreference().set(key: AppPreference.KEY_USER_LAST_NAME, value: lastNameController.text);
            AppPreference().set(key: AppPreference.KEY_USER_Email, value: emailController.text);
            AppPreference().set(key: AppPreference.KEY_USER_DOB, value: dobController.text);
            AppService.userFirstName = firstNameController.text;
          } else {
            emit(state.copyWith(isLoading: false, error: "No profile data found"));
          }
        },
      );
    } catch (e) {
      Utils.closeLoader();
      emit(state.copyWith(isLoading: false, error: e.toString()));
      Utils.showInfoDialog(context: context, title: e.toString());
    }
  }
  String formatDate(String dateTime) {
    try {
      DateTime parsed = DateTime.parse(dateTime);
      return "${parsed.day.toString().padLeft(2, '0')}-"
          "${parsed.month.toString().padLeft(2, '0')}-"
          "${parsed.year}";
    } catch (e) {
      return dateTime; // fallback if parse fails
    }
  }
  void updateProfileImage({required String imagePath}) async {
    emit(state.copyWith(imageFilePath: imagePath));
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      Map<String, String> body = {"user_id": "$userId"};
      final mResult = await _profileUseCase.uploadProfileImage(body: body, imageFile: File(imagePath));
      mResult.fold((error) {}, (result) {
        Utils.closeLoader();
        if (result.data != null) {
          emit(state.copyWith(profileData: state.profileData?.copyWith(profileImage: result.data?.profileImage ?? "")));
        }
      });
    } catch (e) {}
  }

  Future<void> editProfileDetail({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String gender,
    required String dateOfBirth,
    required String mobile_number,
  }) async {
    try {
      Utils.showLoader();
      emit(state.copyWith(isLoading: true));

      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      Map<String, dynamic> body = {
        "user_id": "$userId",
        "first_name": firstName,
        "last_name": lastName,
        "country_code": countryCode,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "mobile_number": mobile_number,
      };

      final mResult = await _profileUseCase.editProfileDetail(body: body);

      mResult.fold(
        (error) {
          print("APP EXCEPTION:: ${error.message}");
          Utils.closeLoader();
          emit(state.copyWith(isLoading: false, error: error.message));
          Utils.showInfoDialog(context: context, title: error.message ?? "Something went wrong");
        },
        (result) {
          Utils.closeLoader();
          if (result.data != null) {
            print("PROFILE UPDATED SUCCESSFULLY:: ${result.data}");
            // emit(state.copyWith(profileData: result.data!, isLoading: false, error: null));
            Utils.showInfoDialog(context: context, title: result.message ?? "Profile updated successfully");
            loadProfile(context,loadForce: true);
          } else {
            emit(state.copyWith(isLoading: false, error: "Failed to update profile"));
            Utils.showInfoDialog(context: context, title: "Failed to update profile");
          }
        },
      );
    } catch (e) {
      Utils.closeLoader();
      emit(state.copyWith(isLoading: false, error: e.toString()));
      Utils.showInfoDialog(context: context, title: e.toString());
    }
  }
}
