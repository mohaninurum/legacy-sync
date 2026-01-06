//package com.legacy.sync
//
//import android.content.Intent
//import android.os.Bundle
//import androidx.activity.ComponentActivity
//import androidx.activity.compose.setContent
//import androidx.compose.foundation.background
//import androidx.compose.foundation.clickable
//import androidx.compose.foundation.layout.*
//import androidx.compose.foundation.shape.CircleShape
//import androidx.compose.material3.Text
//import androidx.compose.runtime.Composable
//import androidx.compose.ui.Alignment
//import androidx.compose.ui.Modifier
//import androidx.compose.ui.graphics.Color
//import androidx.compose.ui.unit.dp
//import androidx.compose.ui.unit.sp
//
//
//class IncomingCallActivity : ComponentActivity() {
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        window.addFlags(
//            android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
//                    android.view.WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
//                    android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
//        )
//
//        val roomId = intent.getStringExtra("room_id") ?: ""
//
//        setContent {
//            IncomingCallComposeUI(
//                onAccept = { openFlutter(roomId) },
//                onDecline = { finish() }
//            )
//        }
//    }
//
//    private fun openFlutter(roomId: String) {
//        val intent = Intent(this, MainActivity::class.java)
//        intent.putExtra("type", "call")
//        intent.putExtra("room_id", roomId)
//        startActivity(intent)
//        finish()
//    }
//}
//
//@Composable
//fun IncomingCallComposeUI(onAccept: () -> Unit, onDecline: () -> Unit) {
//    Box(
//        modifier = Modifier
//            .fillMaxSize()
//            .background(Color.Black),
//        contentAlignment = Alignment.Center
//    ) {
//        Column(horizontalAlignment = Alignment.CenterHorizontally) {
//            Spacer(Modifier.height(40.dp))
//            Text("Incoming Podcast Call", color = Color.White, fontSize = 22.sp)
//            Spacer(Modifier.weight(1f))
//            Row(
//                horizontalArrangement = Arrangement.SpaceEvenly,
//                modifier = Modifier.fillMaxWidth()
//            ) {
//                CallButton(Color.Red, "Decline", onDecline)
//                CallButton(Color.Green, "Accept", onAccept)
//            }
//            Spacer(Modifier.height(60.dp))
//        }
//    }
//}
//
//@Composable
//fun CallButton(color: Color, title: String , onClick: () -> Unit) {
//    Box(
//        modifier = Modifier
//            .size(80.dp)
//            .background(color, CircleShape)
//            .clickable { onClick() },
//        contentAlignment = Alignment.Center
//    ) {
//       Text(title)
//    }
//}
