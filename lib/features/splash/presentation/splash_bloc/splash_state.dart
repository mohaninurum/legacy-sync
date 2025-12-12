import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  const SplashState({
    this.isLoading = true,
    this.isInitialized = false,
    this.error,
  });

  SplashState copyWith({bool? isLoading, bool? isInitialized, String? error}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isInitialized, error];
}
