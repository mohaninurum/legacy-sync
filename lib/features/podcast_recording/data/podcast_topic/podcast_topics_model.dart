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
