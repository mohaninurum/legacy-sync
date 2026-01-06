package com.legacy.sync

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity()

//{
//
//    private val CHANNEL = "local_call_test"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                if (call.method == "showCall") {
//                    IncomingCallNotifier.show(this)
//                    result.success(true)
//                }
//            }
//    }
//}
