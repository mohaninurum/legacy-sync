class InviteFriendResponse {
  final bool status;
  final String message;
  final int invitedFriendId;

  InviteFriendResponse({
    required this.status,
    required this.message,
    required this.invitedFriendId,
  });

  factory InviteFriendResponse.fromJson(Map<String, dynamic> json) {
    return InviteFriendResponse(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
      invitedFriendId: (json['invited_friend_id'] ?? -1) as int,
    );
  }
}
