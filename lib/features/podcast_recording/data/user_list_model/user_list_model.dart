class UserListModel {
  final String id;
  final String name;
  final String? avatar; // image url / asset (optional)
  final bool isOnline;
  final bool isSelf;

  const UserListModel({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = true,
    this.isSelf = false,

  });

  /// Dummy / UI testing data
  factory UserListModel.dummy({
    required String id,
    required String name,
    required String avatar,
  }) {
    return UserListModel(
      id: id,
      name: name,
      avatar: null,
      isOnline: true,
      isSelf: true,
    );
  }

  /// From API / Firebase
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      isOnline: json['is_online'] ?? true,
      isSelf: json['isSelf'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'is_online': isOnline,
      'is_online': isSelf,
    };
  }

  /// Helper: initials for avatar
  String get initials {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
