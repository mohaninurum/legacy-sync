import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../../../../core/colors/colors.dart';
import '../bloc/audio_preview_edit_state.dart';

typedef CallbackSelection = void Function(double seconds);

class RealWaveSlider extends StatefulWidget {
  final String audioPath;
  final double duration; // seconds
  final CallbackSelection onStart;
  final CallbackSelection onEnd;
  final AudioPreviewEditState state;

  const RealWaveSlider({
    super.key,
    required this.audioPath,
    required this.duration,
    required this.onStart,
    required this.onEnd,
    required this.state,
  });

  @override
  State<RealWaveSlider> createState() => _RealWaveSliderState();
}

class _RealWaveSliderState extends State<RealWaveSlider> {
  late final PlayerController _controller;

  double startPx = 0;
  double endPx = 0;

  static const double handleWidth = 20;
  static const double waveHeight = 100;

  double get waveWidth => MediaQuery.of(context).size.width - 32;

  double get secondsPerPixel =>
      widget.duration <= 0 ? 0 : widget.duration / waveWidth;

  double get startTime =>
      (startPx * secondsPerPixel).clamp(0, widget.duration);

  double get endTime =>
      (endPx * secondsPerPixel).clamp(0, widget.duration);

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
    _loadWaveform();
  }

  Future<void> _loadWaveform() async {
    await _controller.preparePlayer(
      path: widget.audioPath,
      shouldExtractWaveform: true,
      noOfSamples: 150,
    );

    setState(() {
      startPx = 0;
      endPx = waveWidth - handleWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: waveHeight,
          width: waveWidth,
          child: Stack(
            children: [
              /// REAL WAVEFORM
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: AudioFileWaveforms(
                  padding: const EdgeInsets.all(0),
                  size: Size(waveWidth, waveHeight),
                  playerController: _controller,
                  waveformType:widget.state.isAudioEdit?  WaveformType.long:WaveformType.fitWidth,
                  playerWaveStyle:  PlayerWaveStyle(
                    waveThickness: 3,
                    seekLineThickness: 1,
                    seekLineColor: AppColors.redColor,
                    showSeekLine: widget.state.isAudioEdit?true:false,
                    fixedWaveColor: AppColors.dart_grey,
                    liveWaveColor: AppColors.whiteColor,
                    spacing: 5,
                    waveCap: StrokeCap.round,
                  ),
                ),
              ),



              if(widget.state.isAudioEdit)
              CenterBar(
                position: startPx + handleWidth,
                width: endPx - startPx - handleWidth,
                callback: (d) {
                  final s = startPx + d.delta.dx;
                  final e = endPx + d.delta.dx;

                  if (s >= 0 && e <= waveWidth - handleWidth) {
                    setState(() {
                      startPx = s;
                      endPx = e;
                    });
                  }
                },
                callbackEnd: (_) {
                  widget.onStart(startTime);
                  widget.onEnd(endTime);
                },
              ),

              if(widget.state.isAudioEdit)
              Bar(
                isLeft: true,
                position: startPx,
                callback: (d) {
                  final next = startPx + d.delta.dx;
                  if (next >= 0 && next < endPx - handleWidth) {
                    setState(() => startPx = next);
                  }
                },
                callbackEnd: (_) => widget.onStart(startTime),
              ),

              if(widget.state.isAudioEdit)
              Bar(
                isLeft: false,
                position: endPx,
                callback: (d) {
                  final next = endPx + d.delta.dx;
                  if (next > startPx + handleWidth &&
                      next <= waveWidth - handleWidth) {
                    setState(() => endPx = next);
                  }
                },
                callbackEnd: (_) => widget.onEnd(endTime),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class Bar extends StatelessWidget {
  final bool isLeft;
  final double position;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback callbackEnd;

  const Bar({
    super.key,
    required this.isLeft,
    required this.position,
    required this.callback,
    required this.callbackEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.clamp(0, double.infinity),
      top: 20,
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          width: 20,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: isLeft
                ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Icon(
            isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}


class CenterBar extends StatelessWidget {
  final double position;
  final double width;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback callbackEnd;

  const CenterBar({
    super.key,
    required this.position,
    required this.width,
    required this.callback,
    required this.callbackEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position,
      top: 20,
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          width: width.clamp(0, double.infinity),
          height: 60,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(height: 3, color: Colors.red),
              const Expanded(child: SizedBox()),
              Container(height: 3, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
