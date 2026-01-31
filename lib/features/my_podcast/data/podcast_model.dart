class PodcastModel {
  final int podcastId;
  final String title;
  final String subtitle;
  final String relationship;
  final String duration;
  final String image;
  final String type; // Posted, Draft, Favorite
  final int totalDurationSec;   // e.g. 1800 (30 min)
  final int listenedSec;        // e.g. 900 (15 min)
  final String author;
  final String description;
  final String summary;
  final String?  audioPath;

  PodcastModel({
    required this.podcastId,
    required this.title,
    required this.subtitle,
    required this.relationship,
    required this.duration,
    required this.image,
    required this.type,
    required this.totalDurationSec,   // e.g. 1800 (30 min)
    required this.listenedSec,        // e.g. 900 (15 min)
    required this.author,
    required this.description
  ,required this.summary
 ,this.audioPath,
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
          .map((e) => PodcastData.fromJson(e))
          .toList(),
    );
  }
}



class PodcastData {
  final int podcastId;
  final String title;
  final String description;
  final String thumbnail;
  final int userId;
  final bool isPosted;
  final int topicId;
  final String livekitRoomId;
  final String audioUrl;
  final int durationSeconds;
  final int listenedSeconds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Member> members;

  PodcastData({
    required this.podcastId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.userId,
    required this.isPosted,
    required this.topicId,
    required this.livekitRoomId,
    required this.audioUrl,
    required this.durationSeconds,
    required this.listenedSeconds,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
  });

  factory PodcastData.fromJson(Map<String, dynamic> json) {
    return PodcastData(
      podcastId: json['podcast_id_PK'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumb_nail'] ?? '',
      userId: json['user_id_FK'] ?? 0,
      isPosted: (json['is_posted'] ?? 0) == 1,
      topicId: json['topic_id_FK'] ?? 0,
      livekitRoomId: json['livekit_room_id'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 0,
      listenedSeconds: json['listened_seconds'] ?? 0, // 👈 null handled
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      members: (json['members'] as List<dynamic>? ?? [])
          .map((e) => Member.fromJson(e))
          .toList(),
    );
  }
}

class Member {
  final String firstName;
  final String lastName;

  Member({
    required this.firstName,
    required this.lastName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

