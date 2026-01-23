class InviteFriendRequest {
  final int userId;
  final int friendId;
  final String roomId;

  InviteFriendRequest({
    required this.userId,
    required this.friendId,
    required this.roomId,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "friend_id": friendId,
    "room_id": roomId,
  };
}
