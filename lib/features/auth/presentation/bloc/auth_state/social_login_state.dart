
import 'package:equatable/equatable.dart';

class SocialLoginState extends Equatable {
  final bool isLoading;
  final bool isFormValid;
  final String? error;
  final bool? signUpSuccess;

  const SocialLoginState({
    this.isLoading = false,
    this.isFormValid = false,
    this.signUpSuccess = false,
    this.error,
  });

  SocialLoginState copyWith({bool? isLoading, bool? isFormValid,bool? signUpSuccess, String? error}) {
    return SocialLoginState(
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      signUpSuccess: signUpSuccess ?? this.signUpSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isFormValid,signUpSuccess, error];
}