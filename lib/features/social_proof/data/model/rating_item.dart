class RatingItem {
  final String id;
  final String userName;
  final String userHandle;
  final String avatarAsset;
  final String testimonial;
  final int rating;
  final bool isVerified;

  const RatingItem({
    required this.id,
    required this.userName,
    required this.userHandle,
    required this.avatarAsset,
    required this.testimonial,
    required this.rating,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userHandle': userHandle,
      'avatarAsset': avatarAsset,
      'testimonial': testimonial,
      'rating': rating,
      'isVerified': isVerified,
    };
  }

  factory RatingItem.fromJson(Map<String, dynamic> json) {
    return RatingItem(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userHandle: json['userHandle'] ?? '',
      avatarAsset: json['avatarAsset'] ?? '',
      testimonial: json['testimonial'] ?? '',
      rating: json['rating'] ?? 5,
      isVerified: json['isVerified'] ?? false,
    );
  }
}
