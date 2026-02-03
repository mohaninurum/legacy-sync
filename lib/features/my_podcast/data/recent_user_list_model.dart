import '../presentation/bloc/my_podcast_state.dart';

class RecentUserListModel {
  final int podcastUserPK;
  final int friendId;
  final String livekitRoomId;

  final String firstName;
  final String lastName;
  final CallType type;
  final bool missed;

  final String date; // raw created_at
  final DateTime dateTime;  // parsed DateTime ✅

  final int durationSeconds;
  final String image; // placeholder

  const RecentUserListModel({
    required this.podcastUserPK,
    required this.friendId,
    required this.livekitRoomId,
    required this.firstName,
    required this.lastName,
    required this.date,
    required this.dateTime,
    required this.type,
    required this.missed,
    required this.durationSeconds,
    required this.image,
  });

  String get fullName => ('$firstName $lastName').trim();

  factory RecentUserListModel.fromJson(Map<String, dynamic> json) {
    final createdAt = (json['created_at'] ?? '').toString(); // "2026-02-02 09:06:20"
    final dt = _parseApiDate(createdAt);

    final callTypeStr = (json['call_type'] ?? '').toString().toLowerCase();
    final callType = callTypeStr == 'incoming' ? CallType.incoming : CallType.outgoing;

    final missed = (json['missed_call'] ?? 0) == 1;

    return RecentUserListModel(
      podcastUserPK: json['podcast_user_PK'] ?? 0,
      friendId: json['friend_id'] ?? 0,
      livekitRoomId: json['livekit_room_id'] ?? '',
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      date: createdAt,
      type: callType,
      missed: missed,
      dateTime: dt,
      durationSeconds: json['duration_seconds'] ?? 0,
      image: '', // API me nahi hai
    );
  }
}

DateTime _parseApiDate(String s) {
  // expects: "yyyy-MM-dd HH:mm:ss"
  // safer parsing without intl:
  try {
    final parts = s.split(' ');
    final d = parts[0].split('-').map(int.parse).toList();
    final t = parts[1].split(':').map(int.parse).toList();
    return DateTime(d[0], d[1], d[2], t[0], t[1], t[2]);
  } catch (_) {
    return DateTime.now();
  }
}