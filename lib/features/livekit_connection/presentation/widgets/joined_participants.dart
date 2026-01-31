//
// import 'package:flutter/material.dart';
// import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
//
// class ParticipantsSheet extends StatelessWidget {
//   final List<FriendsDataList> participants;
//
//   const ParticipantsSheet({super.key, required this.participants});
//
//   @override
//   Widget build(BuildContext context) {
//     // Center floating card like the reference
//     final maxCardWidth = 360.0;
//
//     return SafeArea(
//       child: Stack(
//         children: [
//           // dim background (bottom sheet already adds some dim, but we keep it consistent)
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               color: Colors.black.withOpacity(0.35),
//             ),
//           ),
//
//           // centered card
//           Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: maxCardWidth,
//                 // keep it small, like reference
//                 maxHeight: MediaQuery.of(context).size.height * 0.45,
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2A2833), // slightly lighter dark
//                     borderRadius: BorderRadius.circular(22),
//                     border: Border.all(color: Colors.white.withOpacity(0.08)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.35),
//                         blurRadius: 18,
//                         offset: const Offset(0, 10),
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       _header(context),
//                       const SizedBox(height: 8),
//                       Expanded(child: _list(context)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _header(BuildContext context) {
//     return SizedBox(
//       height: 42,
//       child: Row(
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(10),
//             onTap: () => Navigator.pop(context),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(Icons.close, color: Colors.white, size: 20),
//             ),
//           ),
//           const Spacer(),
//           Text(
//             "Participant",
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//             ),
//           ),
//           const Spacer(),
//           const SizedBox(width: 36), // balance the close icon
//         ],
//       ),
//     );
//   }
//
//   Widget _list(BuildContext context) {
//     return ListView.builder(
//       itemCount: participants.length,
//       padding: EdgeInsets.zero,
//       itemBuilder: (_, i) {
//         final p = participants[i];
//         final name = (p.firstName ?? "").trim().isEmpty
//             ? "User"
//             : p.firstName!.trim();
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: Row(
//             children: [
//               _avatar(p, name),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               _voiceBars(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _avatar(FriendsDataList p, String name) {
//     final img = (p.profileImage ?? '').trim();
//     final hasImg = img.isNotEmpty && !img.endsWith('/null');
//
//     return CircleAvatar(
//       radius: 18,
//       backgroundColor: Colors.white.withOpacity(0.10),
//       backgroundImage: hasImg ? NetworkImage(img) : null,
//       child: hasImg
//           ? null
//           : Text(
//         name.substring(0, 1).toUpperCase(),
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w800,
//         ),
//       ),
//     );
//   }
//
//   // right side bars like the reference
//   Widget _voiceBars() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _bar(8),
//         const SizedBox(width: 3),
//         _bar(12),
//         const SizedBox(width: 3),
//         _bar(16),
//         const SizedBox(width: 3),
//         _bar(20),
//       ],
//     );
//   }
//
//   Widget _bar(double h) {
//     return Container(
//       width: 3,
//       height: h,
//       decoration: BoxDecoration(
//         color: const Color(0xFF29D16F),
//         borderRadius: BorderRadius.circular(99),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';

class ParticipantsSheet extends StatelessWidget {
  final List<FriendsDataList> participants;

  const ParticipantsSheet({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    final maxCardWidth = 360.0;

    return SafeArea(
      child: Stack(
        children: [
          // Dim background
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),

          // ✅ Center floating card
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxCardWidth,

                // ✅ Not fixed height. Just prevents overflow on large lists.
                maxHeight: MediaQuery.of(context).size.height * 0.60,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2833),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ✅ wrap content
                    children: [
                      _header(context),
                      const SizedBox(height: 8),

                      // ✅ content-sized list
                      Flexible(
                        fit: FlexFit.loose,
                        child: _list(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
          const Spacer(),
          Text(
            "Participant",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // ✅ takes only needed height
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(), // feels good if it overflows
      itemCount: participants.length,
      itemBuilder: (_, i) {
        final p = participants[i];
        final sortedName = (p.firstName ?? "").trim().isEmpty ? "User" : p.firstName!.trim();
        final name = sortedName.trim()
            .split(RegExp(r'[ _]+'))
            .first;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _avatar(p, name),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _voiceBars(),
            ],
          ),
        );
      },
    );
  }

  Widget _avatar(FriendsDataList p, String name) {
    final img = (p.profileImage ?? '').trim();
    final hasImg = img.isNotEmpty && !img.endsWith('/null');

    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white.withOpacity(0.10),
      backgroundImage: hasImg ? NetworkImage(img) : null,
      child: hasImg
          ? null
          : Text(
        name.substring(0, 1).toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _voiceBars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bar(6),
        _bar(10),
        _bar(14),
        _bar(10),
        _bar(6),
      ],
    );
  }

  Widget _bar(double height) {
    return Container(
      width: 3,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71), // green wave
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
  // Widget _bar(double h) {
  //   return Container(
  //     width: 3,
  //     height: h,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF29D16F),
  //       borderRadius: BorderRadius.circular(99),
  //     ),
  //   );
  // }
}
