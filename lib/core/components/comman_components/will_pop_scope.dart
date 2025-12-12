import 'package:flutter/cupertino.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/strings/strings.dart';

// class AppWillPopScope extends StatelessWidget {
//   final Widget child;
//   const AppWillPopScope({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           final shouldPop = _showActionSheet(context);
//           if (shouldPop) {
//             Navigator.of(context).pop();
//           }
//         }
//       },
//       child: child,
//     );
//   }
//
//   bool _showActionSheet(BuildContext context) {
//     bool shouldPop = false;
//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoActionSheet(
//           title: const Text(
//             AppStrings.areYouSureYouWantToExit,
//             style: TextStyle(color: AppColors.whiteColor),
//           ),
//           actions: [
//             CupertinoActionSheetAction(
//               onPressed: () {
//                 shouldPop = true;
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 AppStrings.exit,
//                 style: TextStyle(color: AppColors.primaryColorDark),
//               ),
//             ),
//           ],
//           cancelButton: CupertinoActionSheetAction(
//             isDefaultAction: true,
//             isDestructiveAction: true,
//             onPressed: () {
//               shouldPop = false;
//               Navigator.of(context).pop();
//             },
//             child: const Text(AppStrings.cancel),
//           ),
//         );
//       },
//     );
//
//     return shouldPop;
//   }
// }
class AppWillPopScope extends StatelessWidget {
  final Widget child;
  final bool showDialog;
  final Function? onExit; // <-- new callback

  const AppWillPopScope({
    super.key,
    required this.child,
    this.showDialog = true,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (showDialog) {
            final shouldPop = await _showActionSheet(context);
            if (shouldPop == true) {
              if(onExit != null){
                onExit!(true);
              }

            }
          } else {
            onExit!(true);

          }
        }
      },
      child: child,
    );
  }

  Future<bool> _showActionSheet(BuildContext context) async {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text(
            AppStrings.areYouSureYouWantToExit,
            style: TextStyle(color: AppColors.whiteColor),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop(true); // return true
              },
              child: const Text(
                AppStrings.exit,
                style: TextStyle(color: AppColors.primaryColorDark),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(false); // return false
            },
            child: const Text(AppStrings.cancel),
          ),
        );
      },
    );

    return result ?? false;
  }
}
