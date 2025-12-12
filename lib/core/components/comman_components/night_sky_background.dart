import 'package:flutter/material.dart';
import 'dart:math';

class NightSkyBackground extends StatefulWidget {
  final Widget? child;

  const NightSkyBackground({Key? key, this.child}) : super(key: key);

  @override
  State<NightSkyBackground> createState() => _NightSkyBackgroundState();
}

class _NightSkyBackgroundState extends State<NightSkyBackground>
    with TickerProviderStateMixin {
  late List<Star> stars;
  late AnimationController _meteorController;
  late Animation<double> _meteorAnimation;
  bool showMeteor = false;
  Offset meteorStart = Offset.zero;
  Offset meteorEnd = Offset.zero;

  @override
  void initState() {
    super.initState();
    stars = List.generate(50, (index) => Star());

    _meteorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _meteorAnimation = CurvedAnimation(
      parent: _meteorController,
      curve: Curves.easeOut,
    );

    _meteorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showMeteor = false;
        });
        _meteorController.reset();
        _scheduleMeteor();
      }
    });

    _scheduleMeteor();
  }

  void _scheduleMeteor() {
    Future.delayed(Duration(seconds: Random().nextInt(5) + 3), () {
      if (mounted) {
        setState(() {
          showMeteor = true;
          meteorStart = Offset(
            Random().nextDouble() * 0.5 + 0.3,
            Random().nextDouble() * 0.3,
          );
          meteorEnd = Offset(
            meteorStart.dx + 0.2,
            meteorStart.dy + 0.3,
          );
        });
        _meteorController.forward();
      }
    });
  }

  @override
  void dispose() {
    _meteorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A1128),
                Color(0xFF4A27F7),
                Color(0xFF4A27F7),
                Color(0xFF0A1128),
                Color(0xFF000000),
              ],
              stops: [0.0, 0.25, 0.25, 0.75, 1.0],
            ),
          ),
        ),

        // Twinkling Stars
        AnimatedBuilder(
          animation: _meteorAnimation,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: StarsPainter(
                stars: stars,
                time: DateTime.now().millisecondsSinceEpoch / 1000,
              ),
            );
          },
        ),

        // // Meteor
        // if (showMeteor)
        //   AnimatedBuilder(
        //     animation: _meteorAnimation,
        //     builder: (context, child) {
        //       return CustomPaint(
        //         size: Size.infinite,
        //         painter: MeteorPainter(
        //           progress: _meteorAnimation.value,
        //           start: meteorStart,
        //           end: meteorEnd,
        //         ),
        //       );
        //     },
        //   ),

        // Child content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class Star {
  late double x;
  late double y;
  late double size;
  late double twinkleSpeed;
  late double twinkleOffset;
  late double brightness;

  Star() {
    final random = Random();
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 2 + 1;
    twinkleSpeed = random.nextDouble() * 2 + 1;
    twinkleOffset = random.nextDouble() * 2 * pi;
    brightness = random.nextDouble() * 0.5 + 0.5;
  }
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double time;

  StarsPainter({required this.stars, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (var star in stars) {
      final opacity = (sin(time * star.twinkleSpeed + star.twinkleOffset) * 0.5 + 0.5)
          * star.brightness;

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(star.x * size.width, star.y * size.height);

      // Draw star with glow effect
      if (star.size > 1.5) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.3)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 2);
        canvas.drawCircle(position, star.size * 2, glowPaint);
      }

      // Draw main star
      canvas.drawCircle(position, star.size, paint);

      // Draw star points for larger stars
      if (star.size > 1.8) {
        final linePaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.8)
          ..strokeWidth = 0.5;

        canvas.drawLine(
          Offset(position.dx - star.size * 1.5, position.dy),
          Offset(position.dx + star.size * 1.5, position.dy),
          linePaint,
        );
        canvas.drawLine(
          Offset(position.dx, position.dy - star.size * 1.5),
          Offset(position.dx, position.dy + star.size * 1.5),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => true;
}

class MeteorPainter extends CustomPainter {
  final double progress;
  final Offset start;
  final Offset end;

  MeteorPainter({
    required this.progress,
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final currentX = start.dx + (end.dx - start.dx) * progress;
    final currentY = start.dy + (end.dy - start.dy) * progress;
    final currentPos = Offset(currentX * size.width, currentY * size.height);

    final startPos = Offset(start.dx * size.width, start.dy * size.height);

    // Meteor trail gradient
    final trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.withOpacity(0.8),
          Colors.blue.withOpacity(0.4),
          Colors.blue.withOpacity(0.0),
        ],
      ).createShader(Rect.fromPoints(currentPos, startPos))
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw trail
    canvas.drawLine(currentPos, startPos, trailPaint);

    // Draw meteor head glow
    final glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(currentPos, 6, glowPaint);

    // Draw meteor head
    final headPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(currentPos, 3, headPaint);
  }

  @override
  bool shouldRepaint(MeteorPainter oldDelegate) => true;
}

