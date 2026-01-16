class RecentPodcastResponse {
  final bool status;
  final String message;
  final List<PodcastFriend> data;

  RecentPodcastResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecentPodcastResponse.fromJson(Map<String, dynamic> json) {
    return RecentPodcastResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PodcastFriend.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}


class PodcastFriend {
  final int userId;
  final String firstName;
  final String lastName;
  final int durationSeconds;
  final String createdAt;

  PodcastFriend({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.durationSeconds,
    required this.createdAt,
  });

  factory PodcastFriend.fromJson(Map<String, dynamic> json) {
    return PodcastFriend(
      userId: json['user_id_FK'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id_FK': userId,
      'first_name': firstName,
      'last_name': lastName,
      'duration_seconds': durationSeconds,
      'created_at': createdAt,
    };
  }
}
