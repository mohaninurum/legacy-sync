import 'package:legacy_sync/features/livekit_connection/data/model/helper_typecast.dart';

class CancelInviteResponse {
  final bool status;
  final String message;

  CancelInviteResponse({
    required this.status,
    required this.message,
  });

  factory CancelInviteResponse.fromJson(Map<String, dynamic> json) {
    return CancelInviteResponse(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
      // invitedFriendId: (json['invited_friend_id'] ?? -1) as int,
    );
  }
}
