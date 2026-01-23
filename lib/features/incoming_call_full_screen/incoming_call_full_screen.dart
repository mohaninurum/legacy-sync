// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:legacy_sync/core/colors/colors.dart';
// import 'package:legacy_sync/core/extension/extension.dart';
// import 'package:legacy_sync/core/strings/strings.dart';
// import '../../config/routes/routes_name.dart';
// import '../../core/components/comman_components/call_action_button.dart';
// import '../../core/images/images.dart';
//
// class IncomingCallFullScreen extends StatefulWidget {
//   final bool incomingCall;
//   final String roomId;
//   final String callerUserId;
//   final String callerUserName;
//   final String callerProfileImage;
//   final String notificationStatus;
//
//   const IncomingCallFullScreen({
//     super.key,
//     required this.incomingCall,
//     required this.roomId,
//     required this.callerUserId,
//     required this.callerUserName,
//     required this.callerProfileImage,
//     required this.notificationStatus,
//   });
//
//   @override
//   State<IncomingCallFullScreen> createState() => _IncomingCallFullScreenState();
// }
//
// class _IncomingCallFullScreenState extends State<IncomingCallFullScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.teal_accent_Color,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 7.height),
//             SvgPicture.asset(
//               Images.microphone,
//               height: 40,
//               width: 40,
//               color: AppColors.blackColor,
//             ),
//             SizedBox(height: 1.5.height),
//             Text(
//               AppStrings.legacySync,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.blackColor,
//               ),
//             ),
//             SizedBox(height: 1.5.height),
//             Text(
//               AppStrings.invitedPodcast,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.blackColor,
//               ),
//             ),
//             SizedBox(
//               height: 40.height,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     top: 0,
//                     child: Image.asset(Images.user_you),
//                   ),
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: -75,
//                     child: Container(
//                       color: AppColors.teal_accent_Color,
//                       width: 300,
//                       height: 100,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [actionCallButton(), SizedBox(height: 3.height)],
//       ),
//     );
//   }
//
//   Widget actionCallButton() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Column(
//             children: [
//               CallActionButton(
//                 enable: false,
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Icon(
//                   Icons.close,
//                   color: AppColors.whiteColor,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Decline",
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.blackColor,
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               CallActionButton(
//                 enable: true,
//                 onPressed: () {
//                   Navigator.pushNamed(
//                     context,
//                     RoutesName.PODCAST_RECORDING_SCREEN,
//                     arguments: {"incoming_call": true, "userName": "naila"},
//                   );
//                 },
//                 child: const Icon(
//                   Icons.done,
//                   color: AppColors.whiteColor,
//                   size: 30,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "Accept",
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.blackColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import '../../config/routes/routes_name.dart';
import '../../core/components/comman_components/call_action_button.dart';
import '../../core/images/images.dart';

class IncomingCallFullScreen extends StatefulWidget {
  final bool incomingCall;
  final String roomId;
  final String callerUserId;
  final String callerUserName;
  final String callerProfileImage;
  final String notificationStatus;

  const IncomingCallFullScreen({
    super.key,
    required this.incomingCall,
    required this.roomId,
    required this.callerUserId,
    required this.callerUserName,
    required this.callerProfileImage,
    required this.notificationStatus,
  });

  @override
  State<IncomingCallFullScreen> createState() => _IncomingCallFullScreenState();
}

class _IncomingCallFullScreenState extends State<IncomingCallFullScreen> {
  bool _accepting = false;

  @override
  Widget build(BuildContext context) {
    final callerName =
    widget.callerUserName.isNotEmpty ? widget.callerUserName : "Incoming Call";

    return Scaffold(
      backgroundColor: AppColors.teal_accent_Color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 7.height),
            SvgPicture.asset(
              Images.microphone,
              height: 40,
              width: 40,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 1.5.height),
            Text(
              AppStrings.legacySync,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 1.0.height),

            // ✅ Show caller name (host)
            Text(
              callerName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),

            SizedBox(height: 1.0.height),
            Text(
              AppStrings.invitedPodcast,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),

            SizedBox(
              height: 40.height,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: _callerAvatar(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -75,
                    child: Container(
                      color: AppColors.teal_accent_Color,
                      width: 300,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [actionCallButton(), SizedBox(height: 3.height)],
      ),
    );
  }

  Widget _callerAvatar() {
    // ✅ If you have a network image from payload use it, else fallback
    final url = widget.callerProfileImage.trim();

    if (url.isEmpty || url.endsWith('/null')) {
      return Image.asset(Images.user_you);
    }

    return ClipOval(
      child: Image.network(
        url,
        height: 180,
        width: 180,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(Images.user_you),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: 180,
            width: 180,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget actionCallButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              CallActionButton(
                enable: !_accepting,
                onPressed: () {
                  if (_accepting) return;
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Decline",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          Column(
            children: [
              CallActionButton(
                enable: !_accepting,
                onPressed: _acceptCall,
                child: _accepting
                    ? const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(
                  Icons.done,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Accept",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _acceptCall() async {
    if (_accepting) return;

    setState(() => _accepting = true);

    try {
      // ✅ Get current logged-in user details for joining
      final myUserId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      final firstName = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
      final lastName = await AppPreference().get(key: AppPreference.KEY_USER_LAST_NAME);
      final userName = "$firstName $lastName";

      // If you don’t have KEY_USER_NAME in prefs, keep fallback:
      final safeName = (userName.isNotEmpty) ? userName : "You";

      if (!mounted) return;

      // ✅ If your flow should go to PodcastRecordingScreen:
      Navigator.pushReplacementNamed(
        context,
        RoutesName.ROOM_PAGE,
        arguments: {
          "incoming_call": true,
          "userName": safeName,

          // pass these too if PodcastRecordingScreen needs them later
          "roomId": widget.roomId,
          "callerUserId": widget.callerUserId,
          "callerUserName": widget.callerUserName,
          "callerProfileImage": widget.callerProfileImage,
          "notification_status": widget.notificationStatus,
          "userId": myUserId,
        },
      );
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }
}
