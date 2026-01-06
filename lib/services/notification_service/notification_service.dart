import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class NotificationService {

  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, sound: true, badge: true);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    print("onForegroundMessage");
    if (message.data['type'] == 'incoming_call') {
      await _showCall(message.data);
    }
  }

  static Future<void> _onMessageOpened(RemoteMessage message) async {
    print("onMessageOpened");
    if (message.data['type'] == 'incoming_call') {
      await _showCall(message.data);
    }
  }

  static Future<void> _showCall(Map<String, dynamic> data) async {

    final params = CallKitParams(
      id: data['callId'],
      nameCaller: data['callerName'],
      handle: data['roomName'],
      type: int.parse(data['callType']), // 0 audio, 1 video
      duration: 30000,
      extra: {
        'roomName': data['roomName'],
        'token': data['token'],
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
