import 'package:legacy_sync/features/livekit_connection/data/model/helper_typecast.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_state.dart';

class PodcastTopicsModel {
  final String id;
  final String title;
  final String description;
  final TopicCategory category;

  const PodcastTopicsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });
}



class PodcastTopicResponse {
  final bool status;
  final String message;
  final List<PodcastTopic> data;

  PodcastTopicResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PodcastTopicResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = raw is List ? raw : const [];

    return PodcastTopicResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: list
          .whereType<Map>()
          .map((e) => PodcastTopic.fromJson(Map<String, dynamic>.from(e)))
          .toList(),

      // (json['data'] as List<dynamic>?)
      //     ?.map((e) => PodcastTopic.fromJson(e))
      //     .toList() ??
      //     [],
    );
  }
}




class PodcastTopic {
  final int id;
  final String topic;
  final int topicType;
  final bool isShuffle;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PodcastTopic({
    required this.id,
    required this.topic,
    required this.topicType,
    required this.isShuffle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PodcastTopic.fromJson(Map<String, dynamic> json) {
    return PodcastTopic(
      id: HelperTypecast.asInt(json['podcast_topic_id_PK']),
      topic: (json['podcast_topic'] ?? '').toString(),
      topicType: HelperTypecast.asInt(json['topic_type']),
      isShuffle: HelperTypecast.asBool01(json['is_shuffle']),
      createdAt: HelperTypecast.asDateTime(json['created_at']),
      updatedAt: HelperTypecast.asDateTime(json['updated_at']),
    );
  }

  // factory PodcastTopic.fromJson(Map<String, dynamic> json) {
  //   return PodcastTopic(
  //     id: json['podcast_topic_id_PK'] ?? 0,
  //     topic: json['podcast_topic'] ?? '',
  //     topicType: json['topic_type'] ?? 0,
  //     isShuffle: (json['is_shuffle'] ?? 0) == 1,
  //     createdAt: json['created_at'] != null
  //         ? DateTime.tryParse(json['created_at'])
  //         : null,
  //     updatedAt: json['updated_at'] != null
  //         ? DateTime.tryParse(json['updated_at'])
  //         : null,
  //   );
  // }
}
