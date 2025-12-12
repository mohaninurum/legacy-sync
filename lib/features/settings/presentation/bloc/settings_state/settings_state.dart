import 'package:equatable/equatable.dart';
import 'package:legacy_sync/features/settings/data/model/settings_item_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  final bool enableNotifications;
  final bool newFeaturedPosts;
  final bool allNewPosts;

  const SettingsInitial({
    this.enableNotifications = false,
    this.newFeaturedPosts = false,
    this.allNewPosts = false,
  });

  SettingsInitial copyWith({
    bool? enableNotifications,
    bool? newFeaturedPosts,
    bool? allNewPosts,
  }) {
    return SettingsInitial(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      newFeaturedPosts: newFeaturedPosts ?? this.newFeaturedPosts,
      allNewPosts: allNewPosts ?? this.allNewPosts,
    );
  }

  @override
  List<Object?> get props => [
    enableNotifications,
    newFeaturedPosts,
    allNewPosts,
  ];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserProfileModel userProfile;
  final List<SettingsItemModel> settingsItems;
  final bool enableNotifications;
  final bool newFeaturedPosts;
  final bool allNewPosts;

  const SettingsLoaded({
    required this.userProfile,
    required this.settingsItems,
    this.enableNotifications = false,
    this.newFeaturedPosts = false,
    this.allNewPosts = false,
  });

  SettingsLoaded copyWith({
    UserProfileModel? userProfile,
    List<SettingsItemModel>? settingsItems,
    bool? enableNotifications,
    bool? newFeaturedPosts,
    bool? allNewPosts,
  }) {
    return SettingsLoaded(
      userProfile: userProfile ?? this.userProfile,
      settingsItems: settingsItems ?? this.settingsItems,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      newFeaturedPosts: newFeaturedPosts ?? this.newFeaturedPosts,
      allNewPosts: allNewPosts ?? this.allNewPosts,
    );
  }

  @override
  List<Object?> get props => [
    userProfile,
    settingsItems,
    enableNotifications,
    newFeaturedPosts,
    allNewPosts,
  ];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsLogoutInProgress extends SettingsState {}

class SettingsLogoutSuccess extends SettingsState {}

class SettingsLogoutError extends SettingsState {
  final String message;

  const SettingsLogoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationSettingsUpdated extends SettingsState {
  final bool enableNotifications;
  final bool newFeaturedPosts;
  final bool allNewPosts;

  const NotificationSettingsUpdated({
    required this.enableNotifications,
    required this.newFeaturedPosts,
    required this.allNewPosts,
  });

  @override
  List<Object?> get props => [
    enableNotifications,
    newFeaturedPosts,
    allNewPosts,
  ];
}
