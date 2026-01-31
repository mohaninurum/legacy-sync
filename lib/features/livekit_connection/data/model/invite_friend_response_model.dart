import 'package:legacy_sync/features/livekit_connection/data/model/helper_typecast.dart';

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
      invitedFriendId: HelperTypecast.asInt(json['invited_friend_id'], fallback: -1),

      // invitedFriendId: (json['invited_friend_id'] ?? -1) as int,
    );
  }
}
