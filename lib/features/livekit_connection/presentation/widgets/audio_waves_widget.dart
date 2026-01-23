import 'package:flutter/material.dart';

class YouAudioWave extends StatelessWidget {
  final useName;
  const YouAudioWave({super.key,this.useName});

  Widget _bar(double height) {
    return Container(
      width: 3,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71), // green wave
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFB8C0C0), // grey pill
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bar(6),
          _bar(10),
          _bar(14),
          _bar(10),
          _bar(6),
          const SizedBox(width: 8),
           Text(
             useName,
             style: Theme.of(context).textTheme.bodySmall?.copyWith(
               fontSize: 14,
               fontWeight: FontWeight.w600,
             ),
          ),
        ],
      ),
    );
  }
}
