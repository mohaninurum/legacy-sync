import 'package:flutter/cupertino.dart';
import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/auth/data/model/fcm_token_update.dart';
import 'package:legacy_sync/features/auth/data/model/reset_password_model.dart';
import 'package:legacy_sync/features/auth/data/model/signup_model.dart';
import 'package:legacy_sync/features/auth/data/model/social_login_response.dart';

import '../../data/model/email_verification_model.dart';
import '../../data/model/login_model.dart';
import '../../data/model/send_otp_on_email_model.dart';

abstract class AuthRepositories {
  ResultFuture<FcmTokenUpdate> updateFcmToken(Map<String, dynamic> body);
  ResultFuture<SignupModel> signUp(Map<String, dynamic> body);
  ResultFuture<LoginModel> login(Map<String, dynamic> body);
  ResultFuture<SendOtpOnEmailModel> sendOtpOnEmail(Map<String, dynamic> body);
  ResultFuture<ResetPasswordModel> resetPassword(Map<String, dynamic> body);
  ResultFuture<VerifyEmailResponse> emailVerification(Map<String, dynamic> body);
  ResultFuture<SocialLoginResponse> signInWithGoogle();
  ResultFuture<SocialLoginResponse> signInWithApple();
}
