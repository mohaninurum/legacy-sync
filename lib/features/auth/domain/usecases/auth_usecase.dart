import 'package:flutter/cupertino.dart';
import 'package:legacy_sync/features/auth/data/model/social_login_response.dart';

import '../../../../config/network/network_api_service.dart';
import '../../data/model/email_verification_model.dart';
import '../../data/model/login_model.dart';
import '../../data/model/reset_password_model.dart';
import '../../data/model/send_otp_on_email_model.dart';
import '../../data/model/signup_model.dart';
import '../../data/repositories/auth_repo_impl.dart';
import '../repositories/auth_repositories.dart';

class AuthUseCase {
  final AuthRepositories repository = AuthRepoImpl();
  ResultFuture<LoginModel> login({required Map<String, dynamic> body}) async {
    return await repository.login(body);
  }

  ResultFuture<SignupModel> signUp({required Map<String, dynamic> body}) async {
    return await repository.signUp(body);
  }

  ResultFuture<SendOtpOnEmailModel> sendOtpOnEmail({
    required Map<String, dynamic> body,
  }) async {
    return await repository.sendOtpOnEmail(body);
  }

  ResultFuture<ResetPasswordModel> resetPassword({
    required Map<String, dynamic> body,
  }) async {
    return await repository.resetPassword(body);
  }
  ResultFuture<VerifyEmailResponse> emailVerification({
    required Map<String, dynamic> body,
  }) async {
    return await repository.emailVerification(body);
  }

  ResultFuture<SocialLoginResponse> signInWithGoogle() async {
    return await repository.signInWithGoogle();
  }

  ResultFuture<SocialLoginResponse> signInWithApple() async {
    return await repository.signInWithApple();
  }
}
