import 'package:flutter/material.dart';

class YouAudioWave extends StatefulWidget {
  final String? useName;
  final bool isSpeaking;

  const YouAudioWave({super.key, this.useName, this.isSpeaking = false});

  @override
  State<YouAudioWave> createState() => _YouAudioWaveState();
}

class _YouAudioWaveState extends State<YouAudioWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    if (widget.isSpeaking) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(YouAudioWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking && !oldWidget.isSpeaking) {
      _controller.repeat(reverse: true);
    } else if (!widget.isSpeaking && oldWidget.isSpeaking) {
      _controller.stop();
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bar(double heightBase) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final height = widget.isSpeaking ? heightBase + (_controller.value * heightBase * 0.4) : heightBase;
        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isSpeaking ? const Color(0xFF2ECC71) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
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
             widget.useName ?? "",
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
