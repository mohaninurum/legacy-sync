// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
//
// final FlutterLocalNotificationsPlugin notificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> initNotifications() async {
//   const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const settings = InitializationSettings(android: android);
//   await notificationsPlugin.initialize(settings);
// }
//
//
// void showUploadProgress(int progress) {
//   final android = AndroidNotificationDetails(
//     'upload_channel',
//     'Answer Upload',
//     channelDescription: 'Uploading answer video',
//     importance: Importance.low,
//     priority: Priority.low,
//     showProgress: true,
//     maxProgress: 100,
//     progress: progress,
//     onlyAlertOnce: true,
//   );
//
//   notificationsPlugin.show(
//     1001,
//     'Uploading answer',
//     '$progress%',
//     NotificationDetails(android: android),
//   );
// }
//
// void showUploadProgressComplete() {
//   final android = const AndroidNotificationDetails(
//     'upload_channel done',
//     'Answer Upload done',
//     channelDescription: 'Upload answer video done',
//     importance: Importance.max,
//     priority: Priority.max,
//     onlyAlertOnce: true,
//     autoCancel: true,
//   );
//
//   notificationsPlugin.show(
//     1002,
//     'Video Uploaded',
//     'Successfully',
//     NotificationDetails(android: android),
//   );
// }
