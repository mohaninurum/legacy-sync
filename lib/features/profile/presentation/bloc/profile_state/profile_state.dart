import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import '../../../data/model/profile_model.dart';


class ProfileState extends Equatable {
  final ProfileData? profileData;
  final bool isLoading;
  final bool isLoginByApple;
  final String? error;
  final String? imageFilePath ;
  final List<LegacySteps>? steps;

  const ProfileState({this.profileData, this.isLoading = false,this.isLoginByApple = false, this.error,this.imageFilePath, this.steps});

  ProfileState copyWith({
    ProfileData? profileData,
    bool? isLoading,
    bool? isLoginByApple,
    String? error,
    String? imageFilePath,
    List<LegacySteps>? steps,
  }) {
    return ProfileState(
      profileData: profileData ?? this.profileData,
      isLoading: isLoading ?? this.isLoading,
      isLoginByApple: isLoginByApple ?? this.isLoginByApple,
      error: error ?? this.error,
      imageFilePath: imageFilePath ?? this.imageFilePath,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [profileData, isLoading, isLoginByApple, error,imageFilePath,steps];
}

