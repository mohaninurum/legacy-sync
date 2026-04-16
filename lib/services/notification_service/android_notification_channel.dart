import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationChannels {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel incomingCallChannel =
      AndroidNotificationChannel(
        'call_channel',
        'Incoming Call',
        description: 'Used for incoming podcast invitations',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

  static const AndroidNotificationChannel missedCallChannel = AndroidNotificationChannel(
    'missed_call_channel',
    'Missed Call',
    description: 'Used for missed podcast invitations',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: initSettings);

    final androidPlatform =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlatform?.createNotificationChannel(incomingCallChannel);
    await androidPlatform?.createNotificationChannel(missedCallChannel);
  }
}
