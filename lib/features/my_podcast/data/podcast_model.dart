class PodcastModel {
  final String title;
  final String subtitle;
  final String duration;
  final String image;
  final String type; // Posted, Draft, Favorite

  PodcastModel({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.image,
    required this.type,
  });
}
