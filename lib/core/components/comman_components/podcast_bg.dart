import 'package:flutter/material.dart';
import 'package:legacy_sync/core/colors/colors.dart';

class PodcastBg extends StatelessWidget {
  Widget child;
  bool isDark = false;
  PodcastBg({Key? key, required this.child,required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(

              center: Alignment(0.1, isDark? -0.4:-0.7), // Center positioning
              radius: isDark?2.5:1.9,
              colors:  [
                isDark?AppColors.bg_container_second: AppColors.primaryBlueDark, // Light purple center
                AppColors.primaryColorDull,  // Medium purple
                AppColors.primaryColorDull, // Deep purple
                AppColors.primaryColorDull, // Darkest purple
              ],
              stops: const [0.0, 0.3, 0.5, 1.0],
            ),
          ),
        ),
        isDark? Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, 0.5), // Upar positioned
              radius: 1.1,
              colors: [
                AppColors.primaryBlueDark.withOpacity(0.4), // Light with transparency
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ):   Container(
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