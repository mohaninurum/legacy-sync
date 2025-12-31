import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../colors/colors.dart';

class CustomButtonCommonMaskWidgets extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isDisable;

  const CustomButtonCommonMaskWidgets({
    super.key,
    required this.onTap,
    this.text = "Save",
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            fit: StackFit.expand,
            children: [
               DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDisable? [
                      AppColors.dart_grey.withValues(alpha: 07),
                      AppColors.dart_grey,
                      AppColors.dart_grey.withValues(alpha: 0.7),
                    ]:
                    [
                      const Color(0xFF3ED17A),
                      const Color(0xFF3ED17A).withValues(alpha: 0.8),
                      const Color(0xFF3ED17A).withValues(alpha: 0.8),
                      const Color(0xFF3ED17A),
                      const Color(0xFF3ED17A),

                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),

              /// 💡 Center light
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.0,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// 🎨 Grain texture
              CustomPaint(
                painter: GrainPainter(),
              ),

              /// 🔤 Content
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(isDisable==false)
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                  ],
                ),
              ),


              if (isDisable)
                Container(
                  color: Colors.black.withOpacity(0.35),
                ),
            ],
          ),
        ),
      ),
    );
  }
}





class GrainPainter extends CustomPainter {
  final _rand = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 600; i++) {
      final x = _rand.nextDouble() * size.width;
      final y = _rand.nextDouble() * size.height;
      canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
