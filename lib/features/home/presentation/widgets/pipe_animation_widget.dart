import 'package:flutter/material.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';

class PipeAnimationWidget extends StatelessWidget {
  final PipeAnimationModel pipe;
  final bool isLeft;
  final List<JourneyCardModel> cards;
  final double animationProgress;

  const PipeAnimationWidget({
    super.key,
    required this.pipe,
    required this.isLeft,
    required this.cards,
    required this.animationProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (pipe.index >= cards.length - 1) return const SizedBox.shrink();

    final sourceCardColor = _getCardColor(pipe.index);
    final destinationCardColor = _getCardColor(pipe.index + 1);
    final gradientColors = [sourceCardColor, destinationCardColor];

    // Debug print to see animation progress
    if (pipe.isEnabled || animationProgress > 0) {
    }

    return Positioned.fill(
      child: CustomPaint(
        painter: (pipe.isEnabled || animationProgress > 0)
            ? AnimatedConnectorPainter(
                isLeft: isLeft,
                boxWidth: 115,
                boxHeight: 40,
                horizontalMargin: 10,
                verticalSpacing: 90,
                turnFactor: 1.3,
                maxLift: 80,
                strokeWidth: 10,
                gradientColors: gradientColors,
                isEnabled: pipe.isEnabled,
                animationProgress: animationProgress,
              )
            : DisabledPipePainter(
                isLeft: isLeft,
                boxWidth: 115,
                boxHeight: 40,
                horizontalMargin: 10,
                verticalSpacing: 90,
                turnFactor: 1.3,
                maxLift: 80,
                strokeWidth: 10,
                gradientColors: gradientColors,
              ),
      ),
    );
  }

  Color _getCardColor(int cardIndex) {
    if (cardIndex >= cards.length) return Colors.grey;
    return _getColorFromHex(cards[cardIndex].colorCode);
  }

  Color _getColorFromHex(String hexColor) {
    // Remove any existing prefixes and ensure we have a clean hex string
    String cleanHex = hexColor.replaceAll('#', '').replaceAll('0x', '');
    
    // If the hex string doesn't start with FF, add it for alpha
    if (!cleanHex.startsWith('FF')) {
      cleanHex = 'FF$cleanHex';
    }
    
    return Color(int.parse(cleanHex, radix: 16));
  }
}

class DisabledPipePainter extends CustomPainter {
  final bool isLeft;
  final double boxWidth;
  final double boxHeight;
  final double horizontalMargin;
  final double verticalSpacing;
  final double turnFactor;
  final double maxLift;
  final double strokeWidth;
  final List<Color> gradientColors;

  DisabledPipePainter({
    required this.isLeft,
    required this.boxWidth,
    required this.boxHeight,
    required this.horizontalMargin,
    required this.verticalSpacing,
    this.turnFactor = 0.5,
    this.maxLift = 120,
    this.strokeWidth = 6,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(
      isLeft
          ? boxWidth + horizontalMargin
          : size.width - boxWidth - horizontalMargin,
      boxHeight / 2 + verticalSpacing / 2,
    );

    final p3 = Offset(
      isLeft
          ? size.width - boxWidth / 2 - horizontalMargin
          : boxWidth / 2 + horizontalMargin,
      boxHeight / 2 + verticalSpacing * 1.5,
    );

    final c1x = (p1.dx + p3.dx) / 2;
    final c2y = p3.dy - (turnFactor * maxLift);

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(
        c1x,
        p1.dy,
        p3.dx,
        c2y,
        p3.dx,
        p3.dy,
      );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = gradientColors[0].withValues(alpha: 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DisabledPipePainter oldDelegate) {
    return oldDelegate.turnFactor != turnFactor ||
        oldDelegate.maxLift != maxLift ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors;
  }
}

class AnimatedConnectorPainter extends CustomPainter {
  final bool isLeft;
  final double boxWidth;
  final double boxHeight;
  final double horizontalMargin;
  final double verticalSpacing;
  final double turnFactor;
  final double maxLift;
  final double strokeWidth;
  final List<Color> gradientColors;
  final bool isEnabled;
  final double animationProgress;

  AnimatedConnectorPainter({
    required this.isLeft,
    required this.boxWidth,
    required this.boxHeight,
    required this.horizontalMargin,
    required this.verticalSpacing,
    this.turnFactor = 0.5,
    this.maxLift = 120,
    this.strokeWidth = 6,
    this.gradientColors = const [Colors.blue, Colors.purple],
    required this.isEnabled,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Debug print
    if (animationProgress > 0) {
    }

    final p1 = Offset(
      isLeft
          ? boxWidth + horizontalMargin
          : size.width - boxWidth - horizontalMargin,
      boxHeight / 2 + verticalSpacing / 2,
    );

    final p3 = Offset(
      isLeft
          ? size.width - boxWidth / 2 - horizontalMargin
          : boxWidth / 2 + horizontalMargin,
      boxHeight / 2 + verticalSpacing * 1.5,
    );

    final c1x = (p1.dx + p3.dx) / 2;
    final c2y = p3.dy - (turnFactor * maxLift);

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(
        c1x,
        p1.dy,
        p3.dx,
        c2y,
        p3.dx,
        p3.dy,
      );

    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final totalLength = pathMetric.length;
    final animatedLength = totalLength * animationProgress;

    final animatedPath = Path();
    final extractPath = pathMetric.extractPath(0, animatedLength);
    animatedPath.addPath(extractPath, Offset.zero);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = gradientColors[0];

    canvas.drawPath(animatedPath, paint);

    if (animationProgress > 0) {
      final gradientColors = isLeft ? this.gradientColors : this.gradientColors.reversed.toList();

      // Get the bounds of the animated path for proper gradient
      final pathBounds = animatedPath.getBounds();
      
      final gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = LinearGradient(
          colors: gradientColors,
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        ).createShader(pathBounds);

      canvas.drawPath(animatedPath, gradientPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedConnectorPainter oldDelegate) {
    return oldDelegate.turnFactor != turnFactor ||
        oldDelegate.maxLift != maxLift ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.isEnabled != isEnabled ||
        oldDelegate.animationProgress != animationProgress;
  }
}
