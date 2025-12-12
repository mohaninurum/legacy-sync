import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final bool isLoading;
  final bool isFormValid;
  final String? error;
  final int statusCode;
  final bool? signUpSuccess;
  final bool isPasswordFocused;
  final bool showPasswordInfo;
  final bool isConfirmPasswordFocused;
  final bool showConfirmPasswordInfo;

  const SignUpState({
    this.isLoading = false,
    this.isFormValid = false,
    this.signUpSuccess = false,
    this.error,
    this.statusCode=3,
    this.isPasswordFocused = false,
    this.showPasswordInfo = false,
    this.isConfirmPasswordFocused = false,
    this.showConfirmPasswordInfo = false,
  });

  SignUpState copyWith({
    bool? isLoading,
    bool? isFormValid,
    bool? signUpSuccess,
    String? error,
    int? statusCode,
    bool? isPasswordFocused,
    bool? showPasswordInfo,
    bool? isConfirmPasswordFocused,
    bool? showConfirmPasswordInfo,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      signUpSuccess: signUpSuccess ?? this.signUpSuccess,
      error: error,
      statusCode: statusCode??this.statusCode,
      isPasswordFocused: isPasswordFocused ?? this.isPasswordFocused,
      showPasswordInfo: showPasswordInfo ?? this.showPasswordInfo,
      isConfirmPasswordFocused:
          isConfirmPasswordFocused ?? this.isConfirmPasswordFocused,
      showConfirmPasswordInfo:
          showConfirmPasswordInfo ?? this.showConfirmPasswordInfo,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isFormValid,
    signUpSuccess,
    error,
    statusCode,
    isPasswordFocused,
    showPasswordInfo,
    isConfirmPasswordFocused,
    showConfirmPasswordInfo,
  ];
}

class SignUpSuccessState extends SignUpState {}
