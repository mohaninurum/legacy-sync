import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class NotificationService {

  static bool _isIncomingCall(Map<String, dynamic> data) {
    final roomId = (data['room_id'] ?? '').toString();
    if (roomId.isEmpty) return false;

    // if you want to enforce status:
    // return (data['notification_status']?.toString() == '100');

    return true;
  }

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, sound: true, badge: true);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }


  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (_isIncomingCall(message.data)) {
      await _showCall(message.data);
    }
    // if (message.data['type'] == 'incoming_call') {
    //   await _showCall(message.data);
    // }
    print("Notification title: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
    print("Notification data : ${message.data}");
  }

  static Future<void> _onMessageOpened(RemoteMessage message) async {
    print("onMessageOpened");
    if (_isIncomingCall(message.data)) {
      await _showCall(message.data);
    }
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
