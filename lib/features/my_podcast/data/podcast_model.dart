class PodcastModel {
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

  PodcastModel({
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
  });
}
