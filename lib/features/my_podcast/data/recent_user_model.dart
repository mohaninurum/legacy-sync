class RecentPodcastResponse {
  final bool status;
  final String message;
  final List<PodcastFriend> data;

  RecentPodcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecentPodcastResponse.fromJson(Map<String, dynamic> json) {
    return RecentPodcastResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => PodcastFriend.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class PodcastFriend {
  final int podcastUserPK;
  final String livekitRoomId;
  final DateTime createdAt;
  final String callType;
  final int friendId;
  final String firstName;
  final String lastName;
  final int missedCall;
  final int durationSeconds;

  PodcastFriend({
    required this.podcastUserPK,
    required this.livekitRoomId,
    required this.createdAt,
    required this.callType,
    required this.friendId,
    required this.firstName,
    required this.lastName,
    required this.missedCall,
    required this.durationSeconds,

  });

  factory PodcastFriend.fromJson(Map<String, dynamic> json) {
    return PodcastFriend(
      podcastUserPK: json['podcast_user_PK'] ?? 0,
      livekitRoomId: json['livekit_room_id'] ?? '',
      createdAt: _parseApiDate(json['created_at']),
      callType: json['call_type'] ?? '',
      friendId: json['friend_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      missedCall: json['missed_call'] ?? 0,
      durationSeconds: json['duration_seconds'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'podcast_user_PK': podcastUserPK,
      'livekit_room_id': livekitRoomId,
      'created_at': _toApiDate(createdAt),
      'call_type': callType,
      'friend_id': friendId,
      'first_name': firstName,
      'last_name': lastName,
      'missed_call': missedCall,
      'duration_seconds': durationSeconds,

    };
  }

  static DateTime _parseApiDate(dynamic value) {
    final s = (value ?? '').toString().trim();
    if (s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);

    // API format: "yyyy-MM-dd HH:mm:ss"
    // Convert to ISO-ish: "yyyy-MM-ddTHH:mm:ss"
    final iso = s.replaceFirst(' ', 'T');
    return DateTime.tryParse(iso) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _toApiDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}

// class RecentPodcastResponse {
//   final bool status;
//   final String message;
//   final List<PodcastFriend> data;
//
//   RecentPodcastResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory RecentPodcastResponse.fromJson(Map<String, dynamic> json) {
//     return RecentPodcastResponse(
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => PodcastFriend.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
//
// class PodcastFriend {
//   final int userId;
//   final String firstName;
//   final String lastName;
//   final int durationSeconds;
//   final String createdAt;
//
//   PodcastFriend({
//     required this.userId,
//     required this.firstName,
//     required this.lastName,
//     required this.durationSeconds,
//     required this.createdAt,
//   });
//
//   factory PodcastFriend.fromJson(Map<String, dynamic> json) {
//     return PodcastFriend(
//       userId: json['user_id_FK'] ?? 0,
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       durationSeconds: json['duration_seconds'] ?? 0,
//       createdAt: json['created_at'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user_id_FK': userId,
//       'first_name': firstName,
//       'last_name': lastName,
//       'duration_seconds': durationSeconds,
//       'created_at': createdAt,
//     };
//   }
// }
