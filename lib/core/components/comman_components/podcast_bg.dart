import 'package:flutter/material.dart';
import 'package:legacy_sync/core/colors/colors.dart';

class PodcastBg extends StatelessWidget {
  Widget child;
  PodcastBg({Key? key, required this.child,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(

              center: Alignment(0.1, -0.7), // Center positioning
              radius: 1.9,
              colors: [
                AppColors.primaryBlueDark, // Light purple center
                AppColors.primaryColorDull,  // Medium purple
                AppColors.primaryColorDull, // Deep purple
                AppColors.primaryColorDull, // Darkest purple
              ],
              stops: [0.0, 0.3, 0.5, 1.0],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, 1.2), // Upar positioned
              radius: 1.1,
              colors: [
                AppColors.primaryBlueDark.withOpacity(0.6), // Light with transparency
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        SizedBox(height: double.infinity, width: double.infinity, child: child),
      ],
    );

  }
}