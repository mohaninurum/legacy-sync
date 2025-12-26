import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/photo_selection_dialog.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/verification_code_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/verification_code_state.dart';
import 'package:vibration/vibration.dart';

class Utils {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void showInfoDialog({required BuildContext context, required String title, String content = "", String actionsText = AppStrings.okay, Function? onPressed}) {
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text(title),
            content: content.isEmpty ? null : Text(content, style: const TextStyle(color: AppColors.whiteColor, fontSize: 14)),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  navigatorKey.currentState?.pop();
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Text(actionsText, style: const TextStyle(color: AppColors.primaryColorBlue, fontSize: 14)),
              ),
            ],
          ),
    );
  }


  static void showLogOutDialog({required BuildContext context, required String title, String content = "", String actionsText = AppStrings.okay, Function? onPressed}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text(title),
            content: content.isEmpty ? null : Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  navigatorKey.currentState?.pop();

                },
                child:const Text("Cancel", style: TextStyle(color: AppColors.whiteColor, fontSize: 14)),
              ),

              CupertinoDialogAction(
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () {
                  navigatorKey.currentState?.pop();
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Text(actionsText, style: const TextStyle(color: AppColors.redColor, fontSize: 14)),
              ),
            ],
          ),
    );
  }

  static void showRemainingSecondsDialog({required BuildContext context, required String email, required String title, String actionsText = AppStrings.okay, Function? onPressed}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text(title),
            content: BlocBuilder<VerificationCodeCubit, VerificationCodeState>(
              builder: (context, state) {
                return Text(state.remainingSeconds == 0 ? AppStrings.resend_email : "(${state.remainingSeconds})s", style: const TextStyle(color: AppColors.whiteColor, fontSize: 14));
              },
            ),
            actions: [
              BlocConsumer<VerificationCodeCubit, VerificationCodeState>(
                listener: (context, state) {
                  if (state.resentSuccess) {
                    Navigator.pop(context);
                    showInfoDialog(context: context, title: AppStrings.emailSend, content: "${AppStrings.weHaveResendEmail} $email", onPressed: onPressed);
                  }
                },
                builder: (context, state) {
                  return CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      if (!state.loading) {
                        if (state.remainingSeconds == 0) {
                          context.read<VerificationCodeCubit>().resendEmailOtp(email: email);
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: state.loading ? const CupertinoActivityIndicator(radius: 10, color: AppColors.whiteColor) : Text(state.remainingSeconds == 0 ? AppStrings.resend_email : actionsText, style: const TextStyle(color: AppColors.primaryColorBlue, fontSize: 14)),
                  );
                },
              ),
            ],
          ),
    );
  }

  static void vibrateDevice({int duration = 1000}) {
    Vibration.vibrate(duration: duration);
  }

  static void showLoader({String? message}) {
    BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return Container(padding: const EdgeInsets.all(30), decoration: const BoxDecoration(color: AppColors.blackColorDull, borderRadius: BorderRadius.all(Radius.circular(12))), child: const CupertinoActivityIndicator(radius: 12, color: Colors.white));
      },
    );
  }

  static void closeLoader() {
    BotToast.closeAllLoading();
  }



  static void showPhotoDialog({required BuildContext context,required VoidCallback onGalleryPressed,required VoidCallback onCameraPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhotoSelectionDialog(
          onGalleryPressed:onGalleryPressed,
          onCameraPressed: onCameraPressed,
        );
      },
    );
  }





  static String getModuleLottie(String? code) {
    switch (code) {
      case null:
        return LottieFiles.m1q1;
      case "m1q1":
        return LottieFiles.m1q1;
      case "m1q2":
        return LottieFiles.m1q2;
      case "m1q3":
        return LottieFiles.m1q3;
      case "m1q4":
        return LottieFiles.m1q4;
      case "m1q5":
        return LottieFiles.m1q5;
      case "m1q6":
        return LottieFiles.m1q6;
      case "m1q7":
        return LottieFiles.m1q7;
      // Module 2
      case "m2q1":
        return LottieFiles.m2q1;
      case "m2q2":
        return LottieFiles.m2q2;
      case "m2q3":
        return LottieFiles.m2q3;
      case "m2q4":
        return LottieFiles.m2q4;
      case "m2q5":
        return LottieFiles.m2q5;
      case "m2q6":
        return LottieFiles.m2q6;
      case "m2q7":
        return LottieFiles.m2q7;
      // Module 3
      case "m3q1":
        return LottieFiles.m3q1;
      case "m3q2":
        return LottieFiles.m3q2;
      case "m3q3":
        return LottieFiles.m3q3;
      case "m3q4":
        return LottieFiles.m3q4;
      case "m3q5":
        return LottieFiles.m3q5;
      case "m3q6":
        return LottieFiles.m3q6;
      case "m3q7":
        return LottieFiles.m3q7;
      // Module 4
      case "m4q1":
        return LottieFiles.m4q1;
      case "m4q2":
        return LottieFiles.m4q2;
      case "m4q3":
        return LottieFiles.m4q3;
      case "m4q4":
        return LottieFiles.m4q4;
      case "m4q5":
        return LottieFiles.m4q5;
      case "m4q6":
        return LottieFiles.m4q6;
      case "m4q7":
        return LottieFiles.m4q7;
      // Module 5
      case "m5q1":
        return LottieFiles.m5q1;
      case "m5q2":
        return LottieFiles.m5q2;
      case "m5q3":
        return LottieFiles.m5q3;
      case "m5q4":
        return LottieFiles.m5q4;
      case "m5q5":
        return LottieFiles.m5q5;
      case "m5q6":
        return LottieFiles.m5q6;
      case "m5q7":
        return LottieFiles.m5q7;
      // Module 6
      case "m6q1":
        return LottieFiles.m6q1;
      case "m6q2":
        return LottieFiles.m6q2;
      case "m6q3":
        return LottieFiles.m6q3;
      case "m6q4":
        return LottieFiles.m6q4;
      case "m6q5":
        return LottieFiles.m6q5;
      case "m6q6":
        return LottieFiles.m6q6;
      case "m6q7":
        return LottieFiles.m6q7;
      // Module 7
      case "m7q1":
        return LottieFiles.m7q1;
      case "m7q2":
        return LottieFiles.m7q2;
      case "m7q3":
        return LottieFiles.m7q3;
      case "m7q4":
        return LottieFiles.m7q4;
      case "m7q5":
        return LottieFiles.m7q5;
      case "m7q6":
        return LottieFiles.m7q6;
      case "m7q7":
        return LottieFiles.m7q7;
      // Module 8
      case "m8q1":
        return LottieFiles.m8q1;
      case "m8q2":
        return LottieFiles.m8q2;
      case "m8q3":
        return LottieFiles.m8q3;
      case "m8q4":
        return LottieFiles.m8q4;
      case "m8q5":
        return LottieFiles.m8q5;
      case "m8q6":
        return LottieFiles.m8q6;
      case "m8q7":
        return LottieFiles.m8q7;
      default:
        return LottieFiles.m1q1;
    }
  }
  static String getModuleImage(String? code) {
    switch (code) {
      case null:
        return Images.m1q1;
      case "m1q1":
        return Images.m1q1;
      case "m1q2":
        return Images.m1q2;
      case "m1q3":
        return Images.m1q3;
      case "m1q4":
        return Images.m1q4;
      case "m1q5":
        return Images.m1q5;
      case "m1q6":
        return Images.m1q6;
      case "m1q7":
        return Images.m1q7;
      // Module 2
      case "m2q1":
        return Images.m2q1;
      case "m2q2":
        return Images.m2q2;
      case "m2q3":
        return Images.m2q3;
      case "m2q4":
        return Images.m2q4;
      case "m2q5":
        return Images.m2q5;
      case "m2q6":
        return Images.m2q6;
      case "m2q7":
        return Images.m2q7;
      // Module 3
      case "m3q1":
        return Images.m3q1;
      case "m3q2":
        return Images.m3q2;
      case "m3q3":
        return Images.m3q3;
      case "m3q4":
        return Images.m3q4;
      case "m3q5":
        return Images.m3q5;
      case "m3q6":
        return Images.m3q6;
      case "m3q7":
        return Images.m3q7;
      // Module 4
      case "m4q1":
        return Images.m4q1;
      case "m4q2":
        return Images.m4q2;
      case "m4q3":
        return Images.m4q3;
      case "m4q4":
        return Images.m4q4;
      case "m4q5":
        return Images.m4q5;
      case "m4q6":
        return Images.m4q6;
      case "m4q7":
        return Images.m4q7;
      // Module 5
      case "m5q1":
        return Images.m5q1;
      case "m5q2":
        return Images.m5q2;
      case "m5q3":
        return Images.m5q3;
      case "m5q4":
        return Images.m5q4;
      case "m5q5":
        return Images.m5q5;
      case "m5q6":
        return Images.m5q6;
      case "m5q7":
        return Images.m5q7;
      // Module 6
      case "m6q1":
        return Images.m6q1;
      case "m6q2":
        return Images.m6q2;
      case "m6q3":
        return Images.m6q3;
      case "m6q4":
        return Images.m6q4;
      case "m6q5":
        return Images.m6q5;
      case "m6q6":
        return Images.m6q6;
      case "m6q7":
        return Images.m6q7;
      // Module 7
      case "m7q1":
        return Images.m7q1;
      case "m7q2":
        return Images.m7q2;
      case "m7q3":
        return Images.m7q3;
      case "m7q4":
        return Images.m7q4;
      case "m7q5":
        return Images.m7q5;
      case "m7q6":
        return Images.m7q6;
      case "m7q7":
        return Images.m7q7;
      // Module 8
      case "m8q1":
        return Images.m8q1;
      case "m8q2":
        return Images.m8q2;
      case "m8q3":
        return Images.m8q3;
      case "m8q4":
        return Images.m8q4;
      case "m8q5":
        return Images.m8q5;
      case "m8q6":
        return Images.m8q6;
      case "m8q7":
        return Images.m8q7;
      default:
        return Images.m1q1;
    }
  }

  static String getGoalIcons(String? optioncode) {
    switch (optioncode) {
      case null:
        return Images.ic_child_svg;
      case "g1icon":
        return Images.ic_child_svg;
      case "g2icon":
        return Images.ic_family_svg;
      case "g3icon":
        return Images.ic_lifes_svg;
      case "g4icon":
        return Images.ic_career_svg;
      case "g5icon":
        return Images.ic_stars_svg;
      case "g6icon":
        return Images.ic_defining_svg;
      case "g7icon":
        return Images.ic_hopes_svg;
      default:
        return Images.ic_q1o1_svg;
    }
  }

  static Widget getIconWidget(String? optioncode) {
    switch (optioncode) {
      case null:
        return SvgPicture.asset(Images.ic_q1o1_svg, height: 20, width: 20);
      case "q1o1":
        return SvgPicture.asset(Images.ic_q1o1_svg, height: 20, width: 20);
      case "q1o2":
        return SvgPicture.asset(Images.ic_q1o2_svg, height: 20, width: 20);
      case "q1o3":
        return SvgPicture.asset(Images.ic_q1o3_svg, height: 20, width: 20);
      case "q1o4":
        return SvgPicture.asset(Images.ic_q1o4_svg, height: 20, width: 20);
      case "q1o5":
        return SvgPicture.asset(Images.ic_q1o5_svg, height: 20, width: 20);
      case "q1o6":
        return SvgPicture.asset(Images.ic_q1o6_svg, height: 20, width: 20);
      case "q2o1":
        return SvgPicture.asset(Images.ic_q2o1_svg, height: 20, width: 20);
      case "q2o2":
        return SvgPicture.asset(Images.ic_q2o2_svg, height: 20, width: 20);
      case "q2o3":
        return SvgPicture.asset(Images.ic_q2o3_svg, height: 20, width: 20);
      case "q2o4":
        return SvgPicture.asset(Images.ic_q2o4_svg, height: 20, width: 20);
      case "q3o1":
        return SvgPicture.asset(Images.ic_q3o1_svg, height: 20, width: 20);
      case "q3o2":
        return SvgPicture.asset(Images.ic_q3o2_svg, height: 20, width: 20);
      case "q3o3":
        return SvgPicture.asset(Images.ic_q3o3_svg, height: 20, width: 20);
      case "q3o4":
        return SvgPicture.asset(Images.ic_q3o4_svg, height: 20, width: 20);
      case "q4o1":
        return SvgPicture.asset(Images.ic_q4o1_svg, height: 20, width: 20);
      case "q4o2":
        return SvgPicture.asset(Images.ic_q4o2_svg, height: 20, width: 20);
      case "q4o3":
        return SvgPicture.asset(Images.ic_q4o3_svg, height: 20, width: 20);
      case "q4o4":
        return SvgPicture.asset(Images.ic_q4o4_svg, height: 20, width: 20);
      case "q5o1":
        return SvgPicture.asset(Images.ic_q5o1_svg, height: 20, width: 20);
      case "q5o2":
        return SvgPicture.asset(Images.ic_q5o2_svg, height: 20, width: 20);
      case "q5o3":
        return SvgPicture.asset(Images.ic_q5o3_svg, height: 20, width: 20);
      case "q5o4":
        return SvgPicture.asset(Images.ic_q5o4_svg, height: 20, width: 20);
      case "q6o1":
        return SvgPicture.asset(Images.ic_q6o1_svg, height: 20, width: 20);
      case "q6o2":
        return SvgPicture.asset(Images.ic_q6o2_svg, height: 20, width: 20);
      case "q6o3":
        return SvgPicture.asset(Images.ic_q6o3_svg, height: 20, width: 20);
      case "q6o4":
        return SvgPicture.asset(Images.ic_q6o4_svg, height: 20, width: 20);
      case "q7o1":
        return SvgPicture.asset(Images.ic_q7o1_svg, height: 20, width: 20);
      case "q7o2":
        return SvgPicture.asset(Images.ic_q7o2_svg, height: 20, width: 20);
      case "q7o3":
        return SvgPicture.asset(Images.ic_q7o3_svg, height: 20, width: 20);
      case "q7o4":
        return SvgPicture.asset(Images.ic_q7o4_svg, height: 20, width: 20);
      case "q8o1":
        return SvgPicture.asset(Images.ic_q8o1_svg, height: 20, width: 20);
      case "q8o2":
        return SvgPicture.asset(Images.ic_q8o2_svg, height: 20, width: 20);
      case "q8o3":
        return SvgPicture.asset(Images.ic_q8o3_svg, height: 20, width: 20);
      case "q8o4":
        return SvgPicture.asset(Images.ic_q8o4_svg, height: 20, width: 20);
      case "female":
        return SvgPicture.asset(Images.ic_female_svg, height: 20, width: 20);
      case "male":
        return SvgPicture.asset(Images.ic_male_svg, height: 20, width: 20);
      case "google":
        return Image.asset(Images.ic_google, height: 24, width: 24);
      case "x":
        return SvgPicture.asset(Images.ic_x_svg, height: 20, width: 20);
      case "tiktok":
        return SvgPicture.asset(Images.ic_tiktok_svg, height: 20, width: 20);
      case "facebook":
        return SvgPicture.asset(Images.ic_facebook_svg, height: 20, width: 20);
      case "instagram":
        return SvgPicture.asset(Images.ic_insta_svg, height: 20, width: 20);
      case "name":
        return SvgPicture.asset(Images.ic_q1o1_svg, height: 20, width: 20);
      case "age":
        return SvgPicture.asset(Images.ic_q1o1_svg, height: 20, width: 20);
      default:
        return SvgPicture.asset(Images.ic_q1o1_svg, height: 20, width: 20);
    }
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else {
      return Colors.grey;
    }
  }

  static String capitalize(String? value) {
    if (value == null || value.isEmpty) return '';
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return 'Today';
    } else if (diff.inHours < 48) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

 static String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  static String minAndSecDuration(String input) {
    final parts = input.split(':');
    if (parts.length != 2) return input;

    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;

    return '$minutes min $seconds sec';
  }


  static String formatDurationFromString(String input) {
    try {
      final parts = input.split(':'); // [0,00,11.000000]

      final minutes = int.parse(parts[1]);
      final seconds = double.parse(parts[2]).floor();

      if (minutes == 0) return '$seconds sec';
      if (seconds == 0) return '$minutes min';

      return '$minutes min $seconds sec';
    } catch (_) {
      return input;
    }
  }


}
