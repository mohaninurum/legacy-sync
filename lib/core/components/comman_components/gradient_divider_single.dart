import 'package:flutter/material.dart';

class GradientDividerSingle extends StatelessWidget {

  const GradientDividerSingle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ Colors.deepPurple,Colors.grey],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
