import 'package:flutter/material.dart';

class GradientDividerSingleVertical extends StatelessWidget {

  double height;
   GradientDividerSingleVertical({super.key,required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ Colors.deepPurple,Colors.grey],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
