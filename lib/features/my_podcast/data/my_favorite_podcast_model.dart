import 'package:legacy_sync/features/livekit_connection/data/model/helper_typecast.dart';

class FavouritePodcastResponse {
  final bool status;
  final String message;
  final List<FavouritePodcast> data;

  FavouritePodcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FavouritePodcastResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List<dynamic> ? raw : const [];

    return FavouritePodcastResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: list
          .whereType<Map>()
          .map((e) => FavouritePodcast.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      // (json['data'] as List<dynamic>?)
      //     ?.map((e) => FavouritePodcast.fromJson(e))
      //     .toList() ??
      //     [],
    );
  }
}

class FavouritePodcast {
  final int favouritePodcastId;
  final int userId;
  final int podcastId;
  final DateTime? createdAt;

  final String title;
  final String thumbnail;
  final int isPosted;
  final int topicId;
  final String audioUrl;
  final int durationSeconds;

  final String podcastTopic;
  final int topicType;

  final List<Member> members;

  FavouritePodcast({
    required this.favouritePodcastId,
    required this.userId,
    required this.podcastId,
    required this.createdAt,
    required this.title,
    required this.thumbnail,
    required this.isPosted,
    required this.topicId,
    required this.audioUrl,
    required this.durationSeconds,
    required this.podcastTopic,
    required this.topicType,
    required this.members,
  });

  factory FavouritePodcast.fromJson(Map<String, dynamic> json) {
    return FavouritePodcast(
      favouritePodcastId: HelperTypecast.asInt(json['favorite_podcast_id_PK']),
      userId: HelperTypecast.asInt(json['user_id_FK']),
      podcastId: HelperTypecast.asInt(json['podcast_id_FK']),
      createdAt: HelperTypecast.asDateTime(json['created_at']),

      title: HelperTypecast.asString(json['title']),
      thumbnail: HelperTypecast.asString(json['thumb_nail']),
      isPosted: HelperTypecast.asInt(json['is_posted']),
      topicId: HelperTypecast.asInt(json['topic_id_FK']),
      audioUrl: HelperTypecast.asString(json['audio_url']),
      durationSeconds: HelperTypecast.asInt(json['duration_seconds']),

      podcastTopic: HelperTypecast.asString(json['podcast_topic']),
      topicType: HelperTypecast.asInt(json['topic_type']),

      members: (json['members'] is List)
          ? (json['members'] as List)
          .whereType<Map>()
          .map((e) => Member.fromJson(Map<String, dynamic>.from(e)))
          .toList()
          : [],
      // favouritePodcastId: json['favorite_podcast_id_PK'] ?? 0,
      // userId: json['user_id_FK'] ?? 0,
      // podcastId: json['podcast_id_FK'] ?? 0,
      // createdAt: json['created_at'] != null
      //     ? DateTime.tryParse(json['created_at'])
      //     : null,
      // title: json['title'] ?? '',
      // thumbnail: json['thumb_nail'] ?? '',
      // isPosted: json['is_posted'] ?? 0,
      // topicId: json['topic_id_FK'] ?? 0,
      // audioUrl: json['audio_url'] ?? '',
      // durationSeconds: json['duration_seconds'] ?? 0,
      // podcastTopic: json['podcast_topic'] ?? '',
      // topicType: json['topic_type'] ?? 0,
      // members: (json['members'] as List<dynamic>?)
      //     ?.map((e) => Member.fromJson(e))
      //     .toList() ??
      //     [],
    );
  }

  /// 🎯 Helper getters
  bool get isLive => isPosted == 1;

  Duration get duration => Duration(seconds: durationSeconds);
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
