import 'dart:ui';
import 'package:flutter/material.dart';

class CommonAddFab extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final IconData icon;
  final List<Color> gradientColors;
  final Color dividerColor;
  final double dividerHeight;

  const CommonAddFab({
    super.key,
    required this.onTap,
    this.size = 64,
    this.icon = Icons.add,
    this.gradientColors = const [
      Color(0xFF7B6CF6),
      Color(0xFFB39DFF),
    ],
    this.dividerColor = const Color(0xFF4E7CFF),
    this.dividerHeight = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// FAB
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: onTap,
              child: Center(
                child: Icon(
                  icon,
                  size: size * 0.6,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
