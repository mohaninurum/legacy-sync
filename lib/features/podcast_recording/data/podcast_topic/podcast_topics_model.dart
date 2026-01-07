import '../../presentation/bloc/podcast_recording_state.dart';

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
    return PodcastTopicResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PodcastTopic.fromJson(e))
          .toList() ??
          [],
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
      id: json['podcast_topic_id_PK'] ?? 0,
      topic: json['podcast_topic'] ?? '',
      topicType: json['topic_type'] ?? 0,
      isShuffle: (json['is_shuffle'] ?? 0) == 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}
