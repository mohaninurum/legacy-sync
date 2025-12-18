import 'package:flutter/material.dart';

class FocusRing extends StatelessWidget {
  final Offset position;

  const FocusRing(this.position, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 30,
      top: position.dy - 30,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.yellowAccent,
            width: 2,
          ),
        ),
      ),
    );
  }
}
