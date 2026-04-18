class PodcastModel {
  final int podcastId;
  final String title;
  final String relationship;
  final String duration;
  final String image;
  final String type; // Posted, Draft, Favorite
  final int totalDurationSec; // e.g. 1800 (30 min)
  final int listenedSec; // e.g. 900 (15 min)
  final String author;
  final String description;
  final String? audioPath;
  final int isFavourite;
  final String topicType;
  final String? roomId;

  PodcastModel({
    required this.podcastId,
    required this.title,
    required this.relationship,
    required this.duration,
    required this.image,
    required this.type,
    required this.totalDurationSec, // e.g. 1800 (30 min)
    required this.listenedSec, // e.g. 900 (15 min)
    required this.author,
    required this.description,
    this.audioPath,
    required this.isFavourite,
    required this.topicType,
    this.roomId,
  });
}

class PodcastResponse {
  final bool status;
  final String message;
  final List<PodcastData> data;

  PodcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PodcastResponse.fromJson(Map<String, dynamic> json) {
    return PodcastResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PodcastData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PodcastData {
  final int podcastId;
  final String? title;
  final String? description;
  final String thumbnail;
  final int userIdFk;
  final int isPosted; // keep as int because API uses 0/1
  final int? topicIdFk;
  final String livekitRoomId;
  final String? audioUrl;
  final String egressId;
  final int? durationSeconds;
  final int status;
  final String createdAtRaw;     // keep raw if you want exact server string
  final String? updatedAtRaw;
  final int listenedSeconds;
  final int isFavourite; // 0/1
  final List<Member> members;
  final String topicType;

  PodcastData({
    required this.podcastId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.userIdFk,
    required this.isPosted,
    required this.topicIdFk,
    required this.livekitRoomId,
    required this.audioUrl,
    required this.egressId,
    required this.durationSeconds,
    required this.status,
    required this.createdAtRaw,
    required this.updatedAtRaw,
    required this.listenedSeconds,
    required this.isFavourite,
    required this.members,
    required this.topicType,
  });

  bool get posted => isPosted == 1;
  bool get favourite => isFavourite == 1;

  DateTime? get createdAt => _tryParseServerDate(createdAtRaw);
  DateTime? get updatedAt => updatedAtRaw == null ? null : _tryParseServerDate(updatedAtRaw!);

  factory PodcastData.fromJson(Map<String, dynamic> json) {
    return PodcastData(
      podcastId: (json['podcast_id_PK'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,                 // can be null
      description: json['description'] as String?,     // can be null
      thumbnail: (json['thumb_nail'] as String?) ?? '',
      userIdFk: (json['user_id_FK'] as num?)?.toInt() ?? 0,
      isPosted: (json['is_posted'] as num?)?.toInt() ?? 0,
      topicIdFk: (json['topic_id_FK'] as num?)?.toInt(), // can be null
      livekitRoomId: (json['livekit_room_id'] as String?) ?? '',
      audioUrl: json['audio_url'] as String?,          // can be null
      egressId: (json['egress_id'] as String?) ?? '',
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(), // can be null
      status: (json['status'] as num?)?.toInt() ?? 0,
      createdAtRaw: (json['created_at'] as String?) ?? '',
      updatedAtRaw: json['updated_at'] as String?,     // can be null
      listenedSeconds: (json['listened_seconds'] as num?)?.toInt() ?? 0,
      isFavourite: (json['is_favourite'] as num?)?.toInt() ?? 0,
      members: (json['members'] as List<dynamic>? ?? [])
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      topicType: (json['topic_type'] as String?) ?? '',
    );
  }
}

class Member {
  final int userId;
  final String firstName;
  final String lastName;

  Member({
    required this.userId,
    required this.firstName,
    required this.lastName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
    );
  }
}

/// Handles "2026-01-31 10:57:55" (space between date/time)
DateTime? _tryParseServerDate(String raw) {
  if (raw.trim().isEmpty) return null;

  // Convert to ISO-ish: "2026-01-31T10:57:55"
  final normalized = raw.replaceFirst(' ', 'T');
  return DateTime.tryParse(normalized);
}


// class PodcastResponse {
//   final bool status;
//   final String message;
//   final List<PodcastData> data;
//
//   PodcastResponse({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   factory PodcastResponse.fromJson(Map<String, dynamic> json) {
//     return PodcastResponse(
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',
//       data: (json['data'] as List<dynamic>? ?? [])
//           .map((e) => PodcastData.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
//
//
// class PodcastData {
//   final int podcastId;
//   final String title;
//   final String description;
//   final String thumbnail;
//   final int userId;
//   final bool isPosted;
//   final int topicId;
//   final String livekitRoomId;
//   final String audioUrl;
//   final int durationSeconds;
//   final int listenedSeconds;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final List<Member> members;
//
//   PodcastData({
//     required this.podcastId,
//     required this.title,
//     required this.description,
//     required this.thumbnail,
//     required this.userId,
//     required this.isPosted,
//     required this.topicId,
//     required this.livekitRoomId,
//     required this.audioUrl,
//     required this.durationSeconds,
//     required this.listenedSeconds,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.members,
//   });
//
//   factory PodcastData.fromJson(Map<String, dynamic> json) {
//     return PodcastData(
//       podcastId: json['podcast_id_PK'] ?? 0,
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       thumbnail: json['thumb_nail'] ?? '',
//       userId: json['user_id_FK'] ?? 0,
//       isPosted: (json['is_posted'] ?? 0) == 1,
//       topicId: json['topic_id_FK'] ?? 0,
//       livekitRoomId: json['livekit_room_id'] ?? '',
//       audioUrl: json['audio_url'] ?? '',
//       durationSeconds: json['duration_seconds'] ?? 0,
//       listenedSeconds: json['listened_seconds'] ?? 0, // 👈 null handled
//       createdAt: json['created_at'] != null
//           ? DateTime.tryParse(json['created_at'])
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.tryParse(json['updated_at'])
//           : null,
//       members: (json['members'] as List<dynamic>? ?? [])
//           .map((e) => Member.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class Member {
//   final String firstName;
//   final String lastName;
//
//   Member({
//     required this.firstName,
//     required this.lastName,
//   });
//
//   factory Member.fromJson(Map<String, dynamic> json) {
//     return Member(
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//     );
//   }
// }

