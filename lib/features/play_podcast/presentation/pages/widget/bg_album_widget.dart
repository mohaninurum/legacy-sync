import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/extension/extension.dart';

class BgAlbumWidget extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final bool isImage;
  final String url;

  const BgAlbumWidget({
    super.key,
    required this.child,
    required this.isDark,
    required this.isImage,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Stack(
          children: [
            // IMAGE (full height)
            Container(
              width: double.infinity,
              height: 64.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // IMAGE DARKEN OVERLAY (key difference)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 10.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primaryColorDull.withOpacity(0.7),
                      AppColors.primaryColorDull,
                    ],
                  ),
                ),
              ),
            ),

            // CONTENT (controls, text etc)
            // Positioned.fill(child: child),
          ],
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 37.height,
            color: AppColors.primaryColorDull,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                      child: Container(
                        height: 18.height,
                        decoration:  BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [
                          //     Colors.white.withOpacity(0.15),
                          //   ],
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Child Content
        SizedBox(height: double.infinity, width: double.infinity, child: child),
      ],
    );
  }
}
