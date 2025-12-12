import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isFormValid;
  final bool? loginSuccess;
  final String? error;
  final bool isPasswordFocused;
  final bool showPasswordInfo;

  const LoginState({
    this.isLoading = false,
    this.isFormValid = false,
    this.loginSuccess = false,
    this.error,
    this.isPasswordFocused = false,
    this.showPasswordInfo = false,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? loginSuccess,
    bool? isFormValid,
    String? error,
    bool? isPasswordFocused,
    bool? showPasswordInfo,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      error: error,
      isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
      showPasswordInfo: showPasswordInfo ?? this.showPasswordInfo,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isFormValid,
    loginSuccess,
    error,
    isPasswordFocused,
    showPasswordInfo,
  ];
}

class LoginSuccessState extends LoginState {}
