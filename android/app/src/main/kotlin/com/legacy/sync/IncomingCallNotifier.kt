//package com.legacy.sync
//
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import androidx.core.app.NotificationCompat
//
//object IncomingCallNotifier {
//
//    fun show(context: Context) {
//        val intent = Intent(context, IncomingCallActivity::class.java).apply {
//            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
//            putExtra("room_id", "local_test_101")
//        }
//
//        val pendingIntent = PendingIntent.getActivity(
//            context,
//            0,
//            intent,
//            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//        )
//
//        val notification = NotificationCompat.Builder(context, "call_channel")
//            .setSmallIcon(R.drawable.launch_background)
//            .setContentTitle("Incoming Podcast Call")
//            .setContentText("Local test – 3 users joined")
//            .setPriority(NotificationCompat.PRIORITY_MAX)
//            .setCategory(NotificationCompat.CATEGORY_CALL)
//            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
//            .setFullScreenIntent(pendingIntent, true)
//            .setOngoing(true)
//            .build()
//
//        val manager =
//            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//
//        manager.notify(1001, notification)
//    }
//}
