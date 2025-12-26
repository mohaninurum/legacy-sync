class UserListModel {
  final String id;
  final String name;
  final String? avatar;
  final bool isOnline;
  final bool isSelf;

  const UserListModel({
    required this.id,
    required this.name,
    this.avatar,
    this.isOnline = true,
    this.isSelf = false,

  });

}
