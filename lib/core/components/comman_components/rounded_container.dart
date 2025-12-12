import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedContainer extends StatelessWidget {
  final Widget child;
  double paddingTop;
  // ignore: use_super_parameters
  RoundedContainer({Key? key, required this.child, this.paddingTop = 0})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RoundedContainerPainter(),
      child: Padding(padding: EdgeInsets.only(top: paddingTop), child: child),
    );
  }
}

class RoundedContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

    final path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Move up a bit (make it higher for deeper curve)
    path.lineTo(0, size.height * 0.1);

    // Smoother deep curve using better control points
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.0, // Control point 1 (pulls curve up)
      size.width * 0.75,
      size.height * 0.0, // Control point 2 (keeps symmetry)
      size.width,
      size.height * 0.1, // End point (right side)
    );

    // Down to bottom right
    path.lineTo(size.width, size.height);

    // Close the path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
