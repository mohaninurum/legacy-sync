import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import '../../images/images.dart';

class AddToWishlistDialog extends StatelessWidget {
  final VoidCallback? onOkayPressed;
  final Widget? customButton;
  final String title;

   AddToWishlistDialog({
    Key? key,
    this.onOkayPressed,
    this.customButton,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          // Dialog content
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF25232f),
                borderRadius: BorderRadius.circular(25),

              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                const  SizedBox(height: 16),
                  // Lock icon
                  Image.asset(Images.save_ic, width: 50, height: 50),
                  const SizedBox(height: 24),
                  // Title
                   Text(
                    'New memory highlight\nsaved!',
                    style: TextTheme.of(context).bodyMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    'This memories has been saved to favorite and added as a memory highlight.',
                    style: TextTheme.of(context).bodyMedium!.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Button
                  _buildDefaultButton(context),
                  const  SizedBox(height: 5),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultButton(BuildContext context) {
    return CustomButton(
      onPressed: onOkayPressed ?? () => Navigator.of(context).pop(),
      btnText: "Okay",
    );
  }

  static Future<void> show(
      BuildContext context, {
        VoidCallback? onOkayPressed,
        Widget? customButton,

      }) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        barrierDismissible: false,
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddToWishlistDialog(
            onOkayPressed: onOkayPressed,
            customButton: customButton,
            title: "",
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // iOS-like scale and fade animation
          const curve = Curves.easeOutBack;

          // Scale animation
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          // Fade animation
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

}