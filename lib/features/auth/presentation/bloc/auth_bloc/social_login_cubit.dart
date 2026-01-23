import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart' show RoutesName;
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/auth/data/model/social_login_response.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

import '../../../domain/usecases/auth_usecase.dart';
import '../auth_state/social_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  bool _isFormValid = false;
  AuthUseCase authUseCase = AuthUseCase();

  SocialLoginCubit() : super(const SocialLoginState());

  void signInWithGoogle({required BuildContext context}) async {
    Utils.showLoader(message: "Signing In...");
    final result = await authUseCase.signInWithGoogle();
    Utils.closeLoader();
    result.fold(
      (error) {
        Utils.showInfoDialog(context: context, title: error.message ?? "Somehting went wrong");
      },
      (data) {
        saveUserInfo(data, context);
        //Utils.showInfoDialog(context: context, title: "Successfully Signed In", content: "Will navigate to home screen soon");
      },
    );
  }

  void signInWithApple({required BuildContext context}) async {
    Utils.showLoader(message: "Signing In with Apple...");
    final result = await authUseCase.signInWithApple();
    Utils.closeLoader();
    result.fold(
      (error) {
        Utils.showInfoDialog(context: context, title: error.message ?? "Something went wrong");
      },
      (data) {
        saveUserInfo(data, context);
        // Utils.showInfoDialog(context: context, title: "Successfully Signed In", content: "Will navigate to home screen soon");
      },
    );
  }

  void saveUserInfo(SocialLoginResponse data, BuildContext context) async {
    await AppPreference().setInt(key: AppPreference.KEY_USER_ID, value: data.data?.userIdPK ?? 0);
    await AppPreference().set(key: AppPreference.KEY_USER_Email, value: data.data?.email ?? "");
    await AppPreference().set(key: AppPreference.KEY_USER_TOKEN, value: data.data?.token ?? "");
    await AppPreference().set(key: AppPreference.KEY_USER_FIRST_NAME, value: data.data?.firstName ?? "");
    await AppPreference().setInt(key: AppPreference.KEY_LOGIN_TYPE_IS_SOCIAL, value: data.data?.isSocial ?? 0);
    await AppPreference().set(key: AppPreference.KEY_REFERRAL_CODE, value: data.data?.referralCode ?? "");
    await AppPreference().setInt(key: AppPreference.KEY_SOCIAL_LOGIN_PROVIDER, value: data.data?.social_login_provider ?? 0);
    await AppPreference().setBool(key: AppPreference.KEY_SURVEY_SUBMITTED, value: data.data?.surveyQuestionCompleted ?? false);
    AppService.initializeUserData();

    // ✅ update fcm token
    await AppService.updateFcmTokenIfNeeded();

    final isSurveyCompleted = await AppPreference().getBool(
      key: AppPreference.KEY_SURVEY_SUBMITTED,
    );

    if(isSurveyCompleted){
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.HOME_SCREEN,
            (Route<dynamic> route) => false,
      );
    }else{
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.QUESTION_SCREEN, (Route<dynamic> route) => false);
    }
  }
}
