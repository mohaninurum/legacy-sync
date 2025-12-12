import 'package:flutter/material.dart';

class GradientProgressBarReadAndBlackColor extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;
  final Duration duration;
  Color startColor;
  Color endColor;

   GradientProgressBarReadAndBlackColor({super.key,this.startColor =const Color(0xFF000000),this.endColor = const Color(0xFFFF0000), required this.currentStep, required this.totalSteps, this.height = 10.0, this.duration = const Duration(milliseconds: 500)});

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps == 0 ? 0 : (currentStep / (totalSteps == 0 ? 1 : totalSteps)).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Stack(
        children: [
          Container(height: height, width: double.infinity, color: Colors.grey.shade300),
          LayoutBuilder(
            builder: (context, constraints) {
              final fullWidth = constraints.maxWidth;
              return AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                width: fullWidth * progress,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),

                  gradient:  LinearGradient(
                    colors: [
                     startColor,
                      endColor,
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
