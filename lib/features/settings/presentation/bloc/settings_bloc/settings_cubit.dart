import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:legacy_sync/features/settings/data/model/settings_item_model.dart';
import 'package:legacy_sync/features/settings/presentation/bloc/settings_state/settings_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../config/db/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AppPreference _appPreference = AppPreference();
  SettingsCubit() : super(const SettingsInitial());


  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    // Check if review is available
    if (await _inAppReview.isAvailable()) {
      // Opens native rating popup
      await _inAppReview.requestReview();
    } else {
      // Fallback → Open Play Store / App Store page
      await _inAppReview.openStoreListing(
        appStoreId: 'YOUR_IOS_APP_STORE_ID', // Only for iOS
        microsoftStoreId: null,
      );
    }
  }

  Future<void> openEmail() async {
    final Email email = Email(
      body: 'Hello, I need support for...',
      subject: 'App Support',
      recipients: ['support@yourapp.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
    void mLaunchUrl(String url) async {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $url');
      }
    }

  Future<void> loadSettings() async {
    emit(SettingsLoading());

    try {
      // Load notification preferences from shared preferences
      final enableNotifications = await _appPreference.getBool(
        key: AppPreference.KEY_ENABLE_NOTIFICATIONS,
      );
      final newFeaturedPosts = await _appPreference.getBool(
        key: AppPreference.KEY_NEW_FEATURED_POSTS,
      );
      final allNewPosts = await _appPreference.getBool(key: AppPreference.KEY_ALL_NEW_POSTS);

      // Mock user data - replace with actual API call
      final userProfile = UserProfileModel(
        name: 'John Doe',
        email: 'johndoe@gmail.com',
        avatarUrl: null, // You can add an actual URL here
      );


      emit(
        SettingsLoaded(
          userProfile: userProfile,
          settingsItems: [],
          enableNotifications: enableNotifications,
          newFeaturedPosts: newFeaturedPosts,
          allNewPosts: allNewPosts,
        ),
      );
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  // Load only notification settings
  Future<void> loadNotificationSettings() async {
    try {
      final enableNotifications = await _appPreference.getBool(
        key: AppPreference.KEY_ENABLE_NOTIFICATIONS,
      );
      final newFeaturedPosts = await _appPreference.getBool(
        key: AppPreference.KEY_NEW_FEATURED_POSTS,
      );
      final allNewPosts = await _appPreference.getBool(key: AppPreference.KEY_ALL_NEW_POSTS);

      emit(
        SettingsInitial(
          enableNotifications: enableNotifications,
          newFeaturedPosts: newFeaturedPosts,
          allNewPosts: allNewPosts,
        ),
      );
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  // Update notification settings
  Future<void> updateNotificationSettings({
    bool? enableNotifications,
    bool? newFeaturedPosts,
    bool? allNewPosts,
  }) async {
    try {
      // Get current state
      final currentState = state;
      bool currentEnableNotifications = false;
      bool currentNewFeaturedPosts = false;
      bool currentAllNewPosts = false;

      if (currentState is SettingsInitial) {
        currentEnableNotifications = currentState.enableNotifications;
        currentNewFeaturedPosts = currentState.newFeaturedPosts;
        currentAllNewPosts = currentState.allNewPosts;
      } else if (currentState is SettingsLoaded) {
        currentEnableNotifications = currentState.enableNotifications;
        currentNewFeaturedPosts = currentState.newFeaturedPosts;
        currentAllNewPosts = currentState.allNewPosts;
      }

      // Update values
      final updatedEnableNotifications =
          enableNotifications ?? currentEnableNotifications;
      final updatedNewFeaturedPosts =
          newFeaturedPosts ?? currentNewFeaturedPosts;
      final updatedAllNewPosts = allNewPosts ?? currentAllNewPosts;

      // Save to preferences
      await _appPreference.setBool(
        key: AppPreference.KEY_ENABLE_NOTIFICATIONS,
        value: updatedEnableNotifications,
      );
      await _appPreference.setBool(
        key:AppPreference.KEY_NEW_FEATURED_POSTS,
        value: updatedNewFeaturedPosts,
      );
      await _appPreference.setBool(
        key: AppPreference.KEY_ALL_NEW_POSTS,
        value: updatedAllNewPosts,
      );

      // Emit updated state
      emit(
        NotificationSettingsUpdated(
          enableNotifications: updatedEnableNotifications,
          newFeaturedPosts: updatedNewFeaturedPosts,
          allNewPosts: updatedAllNewPosts,
        ),
      );

      // Also update the initial state
      emit(
        SettingsInitial(
          enableNotifications: updatedEnableNotifications,
          newFeaturedPosts: updatedNewFeaturedPosts,
          allNewPosts: updatedAllNewPosts,
        ),
      );
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }


}
