import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/utils/utils.dart';

class NotificationService {
  static bool _initialized = false;

  static bool _isIncomingCall(Map<String, dynamic> data) {
    final roomId = (data['room_id'] ?? '').toString();
    if (roomId.isEmpty) return false;

    return true;
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, sound: true, badge: true);

    // iOS: show notifications while app in foreground (optional but good)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ Wait for APNS token on iOS (prevents apns-token-not-set later)
    await _waitForApnsToken();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
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
    if (!_isIncomingCall(message.data)) return;
    // ✅ App is open -> go to your Flutter screen (NOT CallKit)
    final args = {
      "incoming_call": true,
      "room_id": (message.data['room_id'] ?? "").toString(),
      "user_id": (message.data['user_id'] ?? "").toString(),
      "user_name": (message.data['user_name'] ?? "").toString(),
      "profile_image": (message.data['profile_image'] ?? "").toString(),
      "notification_status": (message.data['notification_status'] ?? "").toString(),
    };

    Utils.navigatorKey.currentState?.pushNamed(
      RoutesName.INCOMING_CALL_FULL_SCREEN,
      arguments: args,
    );

    print("Notification title: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
    print("Notification data : ${message.data}");
  }

  static Future<void> _onMessageOpened(RemoteMessage message) async {
    print("onMessageOpened");
    if (!_isIncomingCall(message.data)) return;

    final args = {
      "incoming_call": true,
      "room_id": (message.data['room_id'] ?? "").toString(),
      "user_id": (message.data['user_id'] ?? "").toString(),
      "user_name": (message.data['user_name'] ?? "").toString(),
      "profile_image": (message.data['profile_image'] ?? "").toString(),
      "notification_status": (message.data['notification_status'] ?? "").toString(),
    };

    Utils.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      RoutesName.ROOM_PAGE,
          (r) => false,
      arguments: args,
    );
  }

  static Future<void> _showCall(Map<String, dynamic> data) async {
    final callId = (data['callId']?.toString().isNotEmpty == true)
        ? data['callId'].toString()
        : DateTime.now().millisecondsSinceEpoch.toString();

    final params = CallKitParams(
      id: callId,
      nameCaller: (data['user_name'] ?? 'Incoming Call').toString(),
      handle: (data['room_id'] ?? 'call').toString(),
      type: int.tryParse((data['callType'] ?? '0').toString()) ?? 0,
      duration: 30000,
      // ✅ IMPORTANT: pass your payload into extra so accept event can read it
      extra: {
        'room_id': (data['room_id'] ?? '').toString(),
        'user_id': (data['user_id'] ?? '').toString(),
        'user_name': (data['user_name'] ?? '').toString(),
        'profile_image': (data['profile_image'] ?? '').toString(),
        'notification_status': (data['notification_status'] ?? '').toString(),
      },
      android: const AndroidParams(

        isCustomNotification: false,
        ringtonePath: 'system_ringtone_default',
      ),
      ios: const IOSParams(
        handleType: 'generic',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
