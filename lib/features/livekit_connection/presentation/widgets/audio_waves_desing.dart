import 'package:flutter/material.dart';
import 'package:legacy_sync/core/colors/colors.dart';

class AudioWaveDesign extends StatelessWidget {
  const AudioWaveDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = [
      12, 28, 18, 34, 22, 40, 16, 30, 20, 45,
      18, 38, 24, 32, 16, 36, 22, 28, 18, 34,
      12, 28, 18, 34, 22, 40, 16,
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: heights.map((h) {
          return Container(
            width: 4,
            height: h.toDouble(),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.dart_red_Color,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }
}
