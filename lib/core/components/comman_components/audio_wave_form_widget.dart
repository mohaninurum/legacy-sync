// import 'package:audio_waveform_view/audio_waveform_view.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
//
// class AudioWaveformWidget extends StatefulWidget {
//   final String audioUrl;
//   Color playedColor;
//   Color unplayedColor;
//   Duration duration;
//   Duration position;
//
//   // Add throttle duration to control update frequency
//   final Duration updateThrottle;
//
//   AudioWaveformWidget({
//     super.key,
//     required this.audioUrl,
//     this.playedColor = Colors.black54,
//     this.unplayedColor = Colors.white,
//     this.duration = Duration.zero,
//     this.position = Duration.zero,
//     this.updateThrottle = const Duration(milliseconds: 800), // Update every 200ms
//   });
//
//   @override
//   State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
// }
//
// class _AudioWaveformWidgetState extends State<AudioWaveformWidget> {
//   double _displayProgress = 0.0;
//   Timer? _updateTimer;
//   bool _shouldUpdate = true;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(AudioWaveformWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//
//     // Throttle updates to slow down the animation
//     if (_shouldUpdate) {
//       _shouldUpdate = false;
//
//       // Calculate new progress
//       final newProgress = widget.duration.inMilliseconds > 0
//           ? widget.position.inMilliseconds / widget.duration.inMilliseconds
//           : 0.0;
//
//       // Update display progress
//       setState(() {
//         _displayProgress = newProgress;
//       });
//
//       // Set timer to allow next update
//       _updateTimer?.cancel();
//       _updateTimer = Timer(widget.updateThrottle, () {
//         _shouldUpdate = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 40,
//       width: double.infinity,
//       child: CustomPaint(
//         painter: WaveformPainter(
//           progress: _displayProgress,
//           playedColor: widget.playedColor,
//           unplayedColor: widget.unplayedColor,
//           max: 2.0,
//           min: 1.0,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _updateTimer?.cancel();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AudioWaveformWidget extends StatefulWidget {
  final bool isPlaying;
  final Color activeColor;
  final Color inactiveColor;
  final double height;
  final double width;
  final double spacingValue;

  const AudioWaveformWidget({
    super.key,
    required this.isPlaying,
    this.activeColor = Colors.black,
    this.inactiveColor = Colors.black,
    this.height = 40.0,
    this.width = double.infinity,
    this.spacingValue=2.0,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPlaying) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              animationValue: _animation.value,
              isPlaying: widget.isPlaying,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
              spacingValue: widget.spacingValue,
            ),
            size: Size(widget.width == double.infinity ? 300 : widget.width, widget.height),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;
  final Color activeColor;
  final Color inactiveColor;
  final double spacingValue;

  WaveformPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.activeColor,
    required this.inactiveColor,
    required this.spacingValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barWidth = 3.0;

    final totalBars = (size.width / (barWidth + spacingValue)).floor();
    final centerY = size.height / 2;

    // Predefined heights for waveform bars (you can customize these)
    final barHeights = [
      0.2, 0.4, 0.8, 0.6, 1.0, 0.7, 0.9, 0.3, 0.5, 0.8,
      0.4, 0.9, 0.6, 0.7, 0.5, 0.8, 0.3, 0.6, 0.9, 0.4,
      0.7, 0.5, 0.8, 0.6, 0.4, 0.9, 0.7, 0.3, 0.8, 0.5
    ];

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + spacingValue) + barWidth / 2;

      // Get base height from predefined array (cycle through if needed)
      final baseHeight = barHeights[i % barHeights.length];

      // Add animation effect if playing
      double animatedHeight = baseHeight;
      if (isPlaying) {
        // Create wave effect across bars
        final waveOffset = (animationValue * 2 * math.pi) + (i * 0.3);
        final waveMultiplier = 0.3 * math.sin(waveOffset);
        animatedHeight = (baseHeight + waveMultiplier).clamp(0.1, 1.0);
      }

      final barHeight = animatedHeight * (size.height * 0.8);
      final topY = centerY - barHeight / 2;
      final bottomY = centerY + barHeight / 2;

      // Create rounded rectangle for each bar
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, topY, barWidth, barHeight),
        const Radius.circular(1.5),
      );

      paint.color = isPlaying ? activeColor : inactiveColor;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}