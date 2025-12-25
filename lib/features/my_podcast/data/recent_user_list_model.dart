import '../presentation/bloc/my_podcast_state.dart';

class RecentUserListModel {
  final String relationship;
  final String duration;
  final String date;
  final String image;
  final CallType type;
  final String author;

  RecentUserListModel({
    required this.relationship,
    required this.duration,
    required this.date,
    required this.image,
    required this.type,
    required this.author
  });
}
