import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/utils/utils.dart';

class NotificationService {
  static bool _initialized = false;

  /// Broadcast stream that fires when the host cancels the invite (status 101)
  static final StreamController<void> _cancelStreamController =
      StreamController<void>.broadcast();
  static Stream<void> get onCallCancelled => _cancelStreamController.stream;

  static bool _isIncomingCall(Map<String, dynamic> data) {
    final roomId = (data['room_id'] ?? '').toString();
    final status = (data['notification_status'] ?? '').toString();
    if (roomId.isEmpty) return false;

    // 100 is invitation, 101 is cancellation
    if (status == "101") return false;

    return true;
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    debugPrint('User granted notification permission: ${settings.authorizationStatus}');

    if (Platform.isIOS) {
      // iOS: show notifications while app in foreground (optional but good)
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _setupAndroidCallPermissions();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      await _onMessageOpened(initialMessage);
    }

    // ✅ Safely fetch FCM token (handles APNS delay on iOS without crashing)
    final token = await getFcmTokenSafely();
    debugPrint('[FCM TOKEN] ${token ?? "Not available yet"}');

  }

  static Future<void> _setupAndroidCallPermissions() async {
    if (!Platform.isAndroid) return;

    try {
      await FlutterCallkitIncoming.requestNotificationPermission({
        "title": "Notification permission",
        "rationaleMessagePermission":
            "Notification permission is required for incoming call alerts.",
        "postNotificationMessageRequired":
            "Please allow notification permission from settings for incoming call alerts.",
      });
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
    }

    try {
      final canUseFullScreen =
          await FlutterCallkitIncoming.canUseFullScreenIntent() ?? false;

      debugPrint("canUseFullScreenIntent: $canUseFullScreen");

      if (!canUseFullScreen) {
        await FlutterCallkitIncoming.requestFullIntentPermission();
      }
    } catch (e) {
      debugPrint('Full screen intent permission request failed: $e');
    }
  }

  /// ✅ Call this from AppService to safely read token without crashing on iOS
  static Future<String?> getFcmTokenSafely() async {
    final messaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      await _waitForApnsToken();
    }

    try {
      return await messaging.getToken();
    } catch (e) {
      // This catches [firebase_messaging/apns-token-not-set] and any other errors
      // so your login flow won't break.
      // ignore: avoid_print
      print("[FCM] getToken failed: $e");
      return null;
    }
  }

  static Future<void> _waitForApnsToken() async {
    if (!Platform.isIOS) return;

    final messaging = FirebaseMessaging.instance;

    // Try multiple times, APNS can be delayed right after app launch / hot restart.
    for (int i = 0; i < 10; i++) {
      final apns = await messaging.getAPNSToken();
      if (apns != null && apns.isNotEmpty) {
        // ignore: avoid_print
        print("[APNS] token ready: $apns");
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // ignore: avoid_print
    print("[APNS] token still not available (will retry later when needed)");
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint("Foreground Notification Payload : ${message.data}");
    final status = (message.data['notification_status'] ?? "").toString();

    if (status == "101") {
      await FlutterCallkitIncoming.endAllCalls();
      _cancelStreamController.add(null);
      return;
    }

    if (!_isIncomingCall(message.data)) return;
    final args = _buildArgs(message.data, isAccepted: false);

    Utils.navigatorKey.currentState?.pushNamed(
      RoutesName.INCOMING_CALL_FULL_SCREEN,
      arguments: args,
    );
  }

  static Future<void> _onMessageOpened(RemoteMessage message) async {
    print("onMessageOpened");
    if (!_isIncomingCall(message.data)) return;

    final args = _buildArgs(message.data, isAccepted: false);

    if (Utils.navigatorKey.currentState == null) {
      await AppPreference().init();
      await AppPreference().set(key: 'pending_call_accept', value: jsonEncode(args));
      return;
    }

    Utils.navigatorKey.currentState?.pushNamed(
      RoutesName.INCOMING_CALL_FULL_SCREEN,
      arguments: args,
    );
  }

  static Map<String, dynamic> _buildArgs(
    Map<String, dynamic> data, {
    required bool isAccepted,
  }) {
    return {
      "incoming_call": true,
      "is_accepted": isAccepted,
      "room_id": (data["room_id"] ?? "").toString(),
      "user_id": (data["user_id"] ?? "").toString(),
      "user_name": (data["user_name"] ?? "").toString(),
      "profile_image": (data["profile_image"] ?? "").toString(),
      "notification_status": (data["notification_status"] ?? "").toString(),
    };
  }

  static Future<void> showIncomingCallFromData(Map<String, dynamic> data) async {
    final roomId = (data["room_id"] ?? "").toString().trim();
    if (roomId.isEmpty) return;

    final params = CallKitParams(
      id: roomId,
      nameCaller: (data['user_name'] ?? 'Incoming Call').toString(),
      handle: roomId,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      appName: 'Legacy Sync',
      extra: {
        "room_id": roomId,
        'user_id': (data['user_id'] ?? '').toString(),
        "user_name": (data["user_name"] ?? "").toString(),
        'profile_image': (data['profile_image'] ?? '').toString(),
        'notification_status': (data['notification_status'] ?? '').toString(),
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isCustomSmallExNotification: true,
        isShowFullLockedScreen: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#09121F',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "call_channel",
        missedCallNotificationChannelName: "missed_call_channel",
        isShowCallID: false,
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        supportsDTMF: true,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
