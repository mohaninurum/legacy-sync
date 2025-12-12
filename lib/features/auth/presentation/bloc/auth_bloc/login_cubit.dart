import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/network/api_host.dart' show ApiURL;
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/login_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

import '../../../../../config/db/shared_preferences.dart';
import '../../../domain/usecases/auth_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  // ignore: unused_field
  bool _isFormValid = false;
  AuthUseCase authUseCase = AuthUseCase();

  LoginCubit() : super(const LoginState());

  void resetState() {
    emit(const LoginState());
  }

  void onPasswordFocusChanged(bool isFocused) {
    emit(state.copyWith(isPasswordFocused: isFocused));
  }

  Future<void> checkFormValidation({required String email, required String password}) async {
    // Email validation
    if (email.isEmpty || !email.isEmail) {
      _isFormValid = false;
      emit(state.copyWith(isFormValid: false, showPasswordInfo: _shouldShowPasswordInfo(password)));
      return;
    }

    // Password empty validation
    if (password.isEmpty) {
      _isFormValid = false;
      emit(state.copyWith(isFormValid: false, showPasswordInfo: false));
      return;
    }
    // Password validation: 8+ chars, uppercase, lowercase, number, special char
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~._\-]).{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      _isFormValid = false;
      emit(state.copyWith(isFormValid: false, showPasswordInfo: _shouldShowPasswordInfo(password)));
      return;
    }

    // If all valid
    _isFormValid = true;
    emit(
      state.copyWith(
        isFormValid: true,
        showPasswordInfo: false, // Hide info when password is valid
      ),
    );
  }

  bool _shouldShowPasswordInfo(String password) {
    // Show info message only when:
    // 1. Password field is focused
    // 2. Password is not empty
    // 3. Password is invalid
    if (!state.isPasswordFocused || password.isEmpty) {
      return false;
    }

    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~._\-]).{8,}$');
    return !passwordRegex.hasMatch(password);
  }

  void login({required String email, required String password}) async {
    Map<String, dynamic> body = {"email": email, "password": password};
    emit(state.copyWith(isLoading: true, error: null, loginSuccess: null));
    var login = await authUseCase.login(body: body);
    emit(state.copyWith(isLoading: false));
    login.fold(
      (failure) {
        print("Login FAIl");
        print("${failure.errorCode}");
        if((failure.errorCode ?? 0) == 403){
          emit(
            state.copyWith(
              error: (failure.errorCode ?? 0) == 403 ? "${failure.message}" : failure.message ?? "Something went wrong please try again later in some time",
              loginSuccess: false,
            ),
          );
        }
        emit(
          state.copyWith(
            error: (failure.errorCode ?? 0) == 404 ? "User dose not exist on legacy. You can registered your self" : failure.message ?? "Something went wrong please try again later in some time",
            loginSuccess: false,
          ),
        );
      },
      (data) {
        print("login data");
        print(data);
        // Add null safety checks to prevent null check operator errors
        if (data.data != null) {
          final userData = data.data!;

          // Store user data with null safety
          AppPreference().setInt(key: AppPreference.KEY_USER_ID, value: userData.user_id ?? 0);
          AppPreference().set(key: AppPreference.KEY_USER_FIRST_NAME, value: userData.firstName ?? '');
          AppPreference().set(key: AppPreference.KEY_USER_LAST_NAME, value: userData.lastName ?? '');
          AppPreference().set(key: AppPreference.KEY_USER_Email, value: userData.email ?? '');
          AppPreference().set(key: AppPreference.KEY_USER_DOB, value: userData.dateOfBirth ?? '');
          AppPreference().set(key: AppPreference.KEY_REFERRAL_CODE, value: userData.referralCode ?? "");
          AppPreference().setInt(key: AppPreference.KEY_LOGIN_TYPE_IS_SOCIAL, value: userData.is_social ?? 0);
          AppPreference().setInt(key: AppPreference.KEY_SOCIAL_LOGIN_PROVIDER, value: userData.social_login_provider ?? 0);
          AppPreference().setBool(key: AppPreference.KEY_SURVEY_SUBMITTED, value: userData.survey_question_completed ?? false);
          AppPreference().set(key: AppPreference.KEY_USER_TOKEN, value: userData.token ?? '');
          AppPreference().setBool(key: AppPreference.KEY_USER_FIRST_VISIT, value: true);
          AppPreference().set(key: AppPreference.LEGACY_STARTED, value: userData.legacy_started ?? '');
          AppPreference().setInt(key: AppPreference.MEMORIES_CAPTURED, value: userData.memories_captured ?? 0);

          AppService.initializeUserData();
          ApiURL.authToken = userData.token ?? '';
          emit(state.copyWith(loginSuccess: true));
          emit(LoginSuccessState());
        } else {
          emit(state.copyWith(error: "Invalid response data", loginSuccess: false));
        }
      },
    );
  }
}
