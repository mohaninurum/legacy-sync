// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class LiveKitApi {
//   LiveKitApi({
//     required this.sandboxId,
//   });
//
//   final String sandboxId;
//
//   Future<String> fetchParticipantToken({
//     required String roomName,
//     required String participantName,
//   }) async {
//     final response = await http.post(
//       Uri.parse('https://cloud-api.livekit.io/api/sandbox/connection-details'),
//       headers: {
//         'Content-Type': 'application/json',
//         'X-Sandbox-ID': sandboxId,
//       },
//       body: jsonEncode({
//         'room_name': roomName,
//         'participant_name': participantName,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       return (jsonDecode(response.body) as Map)['participantToken'] as String;
//     }
//
//     throw Exception("Token error: ${response.statusCode} ${response.body}");
//   }
// }
