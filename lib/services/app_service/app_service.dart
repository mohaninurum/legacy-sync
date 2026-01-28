import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/features/auth/domain/usecases/auth_usecase.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/db/shared_preferences.dart';

class AppService {
  static String userName = "";
  static String userFirstName = "";
  static String cachePath = "";

  static Future<void> initializeUserData() async {
    final f = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    final l = await AppPreference().get(key: AppPreference.KEY_USER_LAST_NAME);
    final token = await AppPreference().get(key: AppPreference.KEY_USER_TOKEN);
    ApiURL.authToken = token;
    userFirstName = f;

    print("User First Name: $f");
    if (l.isEmpty) {
      userName = f;
    } else {
      userName = "$f' $l";
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint("[FCM] Token refreshed: $newToken");
      await updateFcmTokenIfNeeded();
    });
  }

  static Future<void> updateFcmTokenIfNeeded() async {
    try {
      final authToken = await AppPreference().get(
        key: AppPreference.KEY_USER_TOKEN,
      );
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      if (authToken == null || authToken.isEmpty) {
        debugPrint("[FCM] Skipped: user not logged in");
        return;
      }

      final fcm = await FirebaseMessaging.instance.getToken();
      if (fcm == null || fcm.isEmpty) {
        debugPrint("[FCM] Skipped: FCM token is null");
        return;
      }

      final saved = await AppPreference().get(key: AppPreference.KEY_FCM_TOKEN);
      if (saved == fcm) {
        debugPrint("[FCM] Skipped: token already up to date");
        return;
      }

      debugPrint("[FCM] Updating token on backend...");
      debugPrint("[FCM] Token: $fcm");

      final result = await AuthUseCase().updateFcmToken(
        body: {"user_id": userId.toString(), "fcm_token": fcm.toString()},
      );

      result.fold(
        (failure) {
          debugPrint(
            "[FCM] ❌ Update failed: ${failure.message} "
            "(code: ${failure.errorCode})",
          );
        },
        (success) async {
          debugPrint("[FCM] ✅ Token updated successfully");
          await AppPreference().set(
            key: AppPreference.KEY_FCM_TOKEN,
            value: fcm,
          );
        },
      );
      // await AppPreference().set(key: AppPreference.KEY_FCM_TOKEN, value: fcm);
    } catch (e, s) {
      debugPrint("[FCM] ❌ Exception while updating token");
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }


}


class AppLifeCycleTracker with WidgetsBindingObserver {
  static final AppLifeCycleTracker instance = AppLifeCycleTracker._();
  AppLifeCycleTracker._();

  final ValueNotifier<bool> isForeground = ValueNotifier<bool>(false);

  void start() {
    WidgetsBinding.instance.addObserver(this);
    isForeground.value = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isForeground.value = (state == AppLifecycleState.resumed);
  }
}

