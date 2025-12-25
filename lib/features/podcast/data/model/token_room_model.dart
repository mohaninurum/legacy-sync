class TokenRoomModel {
  final String serverUrl;
  final String roomName;
  final String participantName;
  final String participantToken;

  TokenRoomModel({
    required this.serverUrl,
    required this.roomName,
    required this.participantName,
    required this.participantToken,
  });

  /// FROM JSON
  factory TokenRoomModel.fromJson(Map<String, dynamic> json) {
    return TokenRoomModel(
      serverUrl: json['serverUrl'] ?? '',
      roomName: json['roomName'] ?? '',
      participantName: json['participantName'] ?? '',
      participantToken: json['participantToken'] ?? '',
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'serverUrl': serverUrl,
      'roomName': roomName,
      'participantName': participantName,
      'participantToken': participantToken,
    };
  }
}
