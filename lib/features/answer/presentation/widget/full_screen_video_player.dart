import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/colors/colors.dart';

class FullScreenVideoPreview extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPreview({
    super.key,
    required this.controller,
  });

  @override
  State<FullScreenVideoPreview> createState() =>
      _FullScreenVideoPreviewState();
}

class _FullScreenVideoPreviewState extends State<FullScreenVideoPreview> {
  bool _isDragging = false;
  late VoidCallback _videoListener;
  @override
  void initState() {
    super.initState();

    _videoListener = () {
      if (!mounted || _isDragging) return;
      setState(() {}); // 🔥 THIS UPDATES SEEK BAR
    };

    widget.controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoListener);
    super.dispose();
  }


  double get _sliderValue {
    final pos =
    widget.controller.value.position.inMilliseconds.toDouble();
    final dur =
    widget.controller.value.duration.inMilliseconds.toDouble();
    return pos.clamp(0, dur);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),

            /// ⬅ BACK
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            /// ▶ PLAY / PAUSE
            GestureDetector(
              onTap: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
              child: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
                size: 80,
              ),
            ),

            /// 🎚 SEEK BAR
            Positioned(
              bottom: 30,
              left: 16,
              right: 16,
              child: Column(
                children: [

                  Slider(
                    activeColor: AppColors.etbg,
                    min: 0,
                    max: controller.value.duration.inMilliseconds.toDouble(),
                    value: _sliderValue,
                    onChangeStart: (_) {
                      _isDragging = true;
                      controller.pause();
                    },
                    onChanged: (value) {
                      controller.seekTo(
                        Duration(milliseconds: value.toInt()),
                      );
                    },
                    onChangeEnd: (_) {
                      _isDragging = false;
                      controller.play();
                    },
                  ),


                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _format(controller.value.position),
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                      Text(
                        _format(controller.value.duration),
                        style:
                        const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
