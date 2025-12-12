import 'package:equatable/equatable.dart';

class ResetPasswordState extends Equatable {
  final bool isLoading;
  final bool isFormValid;
  final bool otpSendSuccess;
  final String? error;

  const ResetPasswordState({
    this.isLoading = false,
    this.isFormValid = false,
    this.otpSendSuccess = false,
    this.error,
  });

  ResetPasswordState copyWith({
    bool? isLoading,
    bool? isFormValid,
    bool? otpSendSuccess,
    String? error,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      otpSendSuccess: otpSendSuccess ?? this.otpSendSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isFormValid, otpSendSuccess,error];
}

class ResetPasswordIniatialState extends ResetPasswordState {}

class OtpSendOnEmailSuccessfully extends ResetPasswordState {}
