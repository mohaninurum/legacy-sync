class ContinueListeningPodcastResponse {
  final bool status;
  final String message;
  final List<Podcast> data;

  ContinueListeningPodcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContinueListeningPodcastResponse.fromJson(Map<String, dynamic> json) {
    return ContinueListeningPodcastResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Podcast.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Podcast {
  final int podcastId;
  final String title;
  final String description;
  final String thumbnail;
  final int userId;
  final int isPosted;
  final int topicId;
  final String livekitRoomId;
  final String audioUrl;
  final int durationSeconds;
  final int listenedSeconds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Member> members;

  Podcast({
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

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      podcastId: json['podcast_id_PK'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumb_nail'] ?? '',
      userId: json['user_id_FK'] ?? 0,
      isPosted: json['is_posted'] ?? 0,
      topicId: json['topic_id_FK'] ?? 0,
      livekitRoomId: json['livekit_room_id'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 0,
      listenedSeconds: json['listened_seconds'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e))
          .toList() ??
          [],
    );
  }

  /// 🎯 Useful computed property
  double get progress =>
      durationSeconds == 0 ? 0 : listenedSeconds / durationSeconds;
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

  String get fullName => '$firstName $lastName'.trim();
}
