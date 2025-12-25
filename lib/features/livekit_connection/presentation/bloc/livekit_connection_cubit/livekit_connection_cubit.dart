import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LiveKitConnectionCubit {
  static const String _egressUrl =
      "https://cloud-api.livekit.io/v1/egress/start";
  static const String _stopEgressUrl =
      "https://cloud-api.livekit.io/v1/egress/stop";
  // ❌ PRODUCTION me hardcode mat karna
  static const String _apiKey = "APIA9zWAgtd3raT";
  static const String _apiSecret = "UdMudhszUzkNnQgzzRXJpQlAVq6NcNdThLepAHIODvC";

  /// recording start karte waqt egressId save karenge
  static String? _egressId;

  // ================= START RECORDING =================
  static Future<void> startRecording({
    required String roomName,
  }) async {
    print("roomName: $roomName");
    final response = await http.post(
      Uri.parse(_egressUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey:$_apiSecret",
      },
      body: jsonEncode({
        "room_name": roomName,
        "layout": "grid",
        "file_outputs": [
          {
            "filepath": "recordings/$roomName.mp4",
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _egressId = data["egress_id"]; // 🔥 VERY IMPORTANT

      debugPrint("✅ Recording started");
      debugPrint("Egress ID: $_egressId");
    } else {
      debugPrint("❌ Failed to start recording");
      debugPrint(response.body);
      throw Exception("Recording start failed");
    }
  }

  // ================= STOP RECORDING =================
  static Future<void> stopRecording() async {
    if (_egressId == null) {
      debugPrint("⚠️ No active recording to stop");
      return;
    }

    final response = await http.post(
      Uri.parse(_stopEgressUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey:$_apiSecret",
      },
      body: jsonEncode({
        "egress_id": _egressId,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint("🛑 Recording stopped");
      _egressId = null;
    } else {
      debugPrint("❌ Failed to stop recording");
      debugPrint(response.body);
      throw Exception("Recording stop failed");
    }
  }
  }

