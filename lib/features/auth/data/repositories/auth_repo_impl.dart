import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/auth/data/model/fcm_token_update.dart';
import 'package:legacy_sync/features/auth/data/model/login_model.dart';
import 'package:legacy_sync/features/auth/data/model/reset_password_model.dart';
import 'package:legacy_sync/features/auth/data/model/send_otp_on_email_model.dart';
import 'package:legacy_sync/features/auth/data/model/signup_model.dart';
import 'package:legacy_sync/features/auth/domain/repositories/auth_repositories.dart';
import 'package:legacy_sync/services/firebase_service/firebase_service.dart';
import 'package:legacy_sync/services/apple_service/apple_service.dart';
import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../model/email_verification_model.dart';
import '../model/social_login_response.dart';

class AuthRepoImpl extends AuthRepositories {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<FcmTokenUpdate> updateFcmToken(Map<String, dynamic> body) async {
    try{
      final res = await _apiServices.getPostApiResponse(ApiURL.updateToken, body);
      return res.fold((error) => Left(error), (data) => Right(FcmTokenUpdate.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SignupModel> signUp(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.sign_up, body);
      return res.fold((error) => Left(error), (data) => Right(SignupModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<LoginModel> login(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.sign_IN, body);
      return res.fold((error) => Left(error), (data) => Right(LoginModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SendOtpOnEmailModel> sendOtpOnEmail(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.SEND_OTP_ON_EMAIL, body);
      return res.fold((error) => Left(error), (data) => Right(SendOtpOnEmailModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<ResetPasswordModel> resetPassword(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.RESET_PASSWORD, body);
      return res.fold((error) => Left(error), (data) => Right(ResetPasswordModel.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }
  @override
  ResultFuture<VerifyEmailResponse> emailVerification(Map<String, dynamic> body) async {
    try {
      final res = await _apiServices.getPostApiResponse(ApiURL.varify_email, body);
      return res.fold((error) => Left(error), (data) => Right(VerifyEmailResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SocialLoginResponse> signInWithGoogle() async {
    try {
      final Completer<Either<AppException, SocialLoginResponse>> completer = Completer();
      FirebaseService firebaseService = FirebaseService();

      await firebaseService.signInWithGoogle(
        onFailure: (failedMessage) {
          AppException appException = AppException(failedMessage, 00, "");
          completer.complete(Left(appException));
        },
        onSuccess: (userData) async {
          print("User Data: $userData");
          Map<String, dynamic> body = {"email": userData["email"] ?? "", "name": userData["name"] ?? "", "social_id": userData["uid"] ?? "", "social_provider": 1};

          try {
            final res = await _apiServices.getPostApiResponse(ApiURL.social_login, body);
            print("API Response received for Google login");
            res.fold((error) => completer.complete(Left(error)), (data) => completer.complete(Right(SocialLoginResponse.fromJson(data))));
          } catch (e) {
            AppException appException = AppException(e.toString(), 500, "");
            completer.complete(Left(appException));
          }
        },
      );

      return await completer.future;
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  ResultFuture<SocialLoginResponse> signInWithApple() async {
    try {
      final Completer<Either<AppException, SocialLoginResponse>> completer = Completer();
      AppleService appleService = AppleService();

      await appleService.signInWithApple(
        onFailure: (failedMessage) {
          AppException appException = AppException(failedMessage, 00, "");
          completer.complete(Left(appException));
        },
        onSuccess: (userData) async {
          Map<String, dynamic> body = {"social_id": userData, "social_provider": 2};

          try {
            final res = await _apiServices.getPostApiResponse(ApiURL.social_login, body);
            print("API Response received for Apple login");
            res.fold((error) => completer.complete(Left(error)), (data) => completer.complete(Right(SocialLoginResponse.fromJson(data))));
          } catch (e) {
            AppException appException = AppException(e.toString(), 500, "");
            completer.complete(Left(appException));
          }
        },
      );

      return await completer.future;
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
