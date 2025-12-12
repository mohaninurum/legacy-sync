import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/network/api_host.dart' show ApiURL;
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/auth/domain/usecases/auth_usecase.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/signup_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';
import '../../../../../config/db/shared_preferences.dart';

class SignUpCubit extends Cubit<SignUpState> {
  // ignore: unused_field
  bool _isFormValid = false;
  AuthUseCase authUseCase = AuthUseCase();

  SignUpCubit() : super(const SignUpState());

  void resetState() {
    emit(const SignUpState());
  }

  void onPasswordFocusChanged(bool isFocused) {
    emit(state.copyWith(isPasswordFocused: isFocused));
  }

  void onConfirmPasswordFocusChanged(bool isFocused) {
    emit(state.copyWith(isConfirmPasswordFocused: isFocused));
  }

  Future<void> checkFormValidation({
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String password,
    required String confirmPassword,
  }) async {
    // Check all fields
    if (firstName.isEmpty) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: _shouldShowPasswordInfo(password),
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    if (lastName.isEmpty) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: _shouldShowPasswordInfo(password),
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    if (email.isEmpty || !email.isEmail) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: _shouldShowPasswordInfo(password),
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    if (dob.isEmpty) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: _shouldShowPasswordInfo(password),
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    // Password empty validation
    if (password.isEmpty) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: false,
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    // Password validation: 8+ chars, uppercase, lowercase, number, special char
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~._\-]).{8,}$',
    );

    if (!passwordRegex.hasMatch(password)) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: _shouldShowPasswordInfo(password),
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: false, // Hide info when password is valid
          showConfirmPasswordInfo: false,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      _isFormValid = false;
      emit(
        state.copyWith(
          isFormValid: false,
          showPasswordInfo: false, // Hide info when password is valid
          showConfirmPasswordInfo: _shouldShowConfirmPasswordInfo(
            password,
            confirmPassword,
          ),
        ),
      );
      return;
    }

    // If all valid
    _isFormValid = true;
    emit(
      state.copyWith(
        isFormValid: true,
        showPasswordInfo: false, // Hide info when password is valid
        showConfirmPasswordInfo: false, // Hide info when passwords match
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

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~._\-]).{8,}$',
    );
    return !passwordRegex.hasMatch(password);
  }

  bool _shouldShowConfirmPasswordInfo(String password, String confirmPassword) {
    // Show info message only when:
    // 1. Confirm password field is focused
    // 2. Confirm password is not empty
    // 3. Passwords don't match
    if (!state.isConfirmPasswordFocused || confirmPassword.isEmpty) {
      return false;
    }

    return password != confirmPassword;
  }

  void signup({
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String password,
    required String confirmPassword,
  }) async {
    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "date_of_birth": dob,
      "password": password,
    };
    emit(state.copyWith(isLoading: true, error: null, signUpSuccess: null));
    print("body $body");
    var signUp = await authUseCase.signUp(body: body);
    emit(state.copyWith(isLoading: false));
    signUp.fold(
      (failure) {
        emit(
          state.copyWith(
            error:
                failure.message ??
                "Something went wrong please try again later in some time",
            signUpSuccess: false,
          ),
        );
      },
      (data) {
        // Add null safety checks to prevent null check operator errors
        if (data.data != null) {
          final userData = data.data!;
          // Store user data with null safety
          AppPreference().setInt(
            key: AppPreference.KEY_USER_ID,
            value: userData.user_id ?? 0,
          );
          AppPreference().set(
            key: AppPreference.KEY_USER_Email,
            value: userData.email ?? '',
          );
          AppPreference().set(
            key: AppPreference.KEY_USER_FIRST_NAME,
            value: userData.firstName ?? '',
          );
          AppPreference().set(
            key: AppPreference.KEY_USER_LAST_NAME,
            value: userData.lastName ?? '',
          );
          AppPreference().set(
            key: AppPreference.KEY_USER_TOKEN,
            value: userData.token ?? '',
          );
          AppPreference().set(
            key: AppPreference.KEY_USER_DOB,
            value: userData.dateOfBirth ?? '',
          );
          AppPreference().setInt(
            key: AppPreference.KEY_LOGIN_TYPE_IS_SOCIAL,
            value: userData.is_social ?? 0,
          );
          AppPreference().set(
            key: AppPreference.KEY_REFERRAL_CODE,
            value: userData.referralCode ?? "",
          );
          AppPreference().setInt(
            key: AppPreference.KEY_SOCIAL_LOGIN_PROVIDER,
            value: userData.social_login_provider ?? 0,
          );
          ApiURL.authToken = userData.token ?? '';
          AppService.initializeUserData();
          emit(state.copyWith(signUpSuccess: true));
          emit(SignUpSuccessState());
        } else {
          emit(
            state.copyWith(
              error: "Invalid response data",
              signUpSuccess: false,
            ),
          );
        }
      },
    );
  }
}
