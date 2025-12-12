import 'package:equatable/equatable.dart';

class VerificationCodeState extends Equatable {
  final int remainingSeconds;
  final bool canResend;
  final bool resentSuccess;
  final bool loading;
  final bool buttonIsEnable;
  String? error;

   VerificationCodeState({
    this.remainingSeconds = 60,
    this.canResend = false,
    this.buttonIsEnable = false,
    this.resentSuccess = false,
    this.loading = false,
    this.error,
  });

  VerificationCodeState copyWith({
    int? remainingSeconds,
    bool? canResend,
    bool? resentSuccess,
    bool? loading,
    bool? buttonIsEnable,
    String? error,
  }) {
    return VerificationCodeState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      canResend: canResend ?? this.canResend,
      resentSuccess: resentSuccess ?? this.resentSuccess,
      loading: loading ?? this.loading,
      buttonIsEnable: buttonIsEnable ?? this.buttonIsEnable,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    remainingSeconds,
    canResend,
    resentSuccess,
    loading,
    buttonIsEnable,
    error,
  ];
}

class OTPValidState extends VerificationCodeState {}

class OTPEnvalidState extends VerificationCodeState {}
