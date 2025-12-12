import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_wave_form_widget.dart';

class AudioMessageWidget extends StatefulWidget {
   String audioUrl;

   AudioMessageWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPressed = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.setSourceUrl(widget.audioUrl);

    // Listen duration
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    // Listen position
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    // Listen completion
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() => isPlaying = !isPlaying);
  }

  String _formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xffdddddd), borderRadius: BorderRadius.circular(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayPause,
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 35,
              height: 35,
              decoration: const BoxDecoration(color: Color(0xffa630ff) ,shape: BoxShape.circle),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,size: 18),
            ),
          ),
          const SizedBox(width: 16),
          // Slider
          Expanded(
            child:  AudioWaveformWidget(isPlaying: isPlaying),
          ),
          const SizedBox(width: 16),
          Text(_formatTime(duration), style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
