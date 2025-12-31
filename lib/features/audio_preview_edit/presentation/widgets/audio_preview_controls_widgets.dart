import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/RealWaveSlider.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/wave_slider_widges.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/waveform_view_widget.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/audio_wave_form_widget.dart';
import '../../../../core/images/images.dart';
import '../bloc/audio_preview_edit_cubit.dart';
import '../bloc/audio_preview_edit_state.dart';

class AudioPreviewControls extends StatelessWidget {
  final AudioPreviewEditState state;
  final AudioPreviewEditCubit cubit;
  final String audioPath;

  const AudioPreviewControls({
    super.key,
    required this.state,
    required this.cubit,
    required this.audioPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 195,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          // padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2B2F4A),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
        state.isAudioInitial?
        RealWaveSlider( state: state, audioPath: audioPath, duration: state.duration.inSeconds.toDouble(), onStart: (seconds) {
              print("onStart $seconds");
        cubit.onStartTrimSecond(seconds);
            }, onEnd: (seconds) {
          cubit.onEndTrimSecond(seconds);
              print("onEnd $seconds");
            },):const SizedBox.shrink()
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment:
                state.isAudioEdit
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
            children: [
              if (state.isAudioEdit)
                InkWell(
                  onTap: () {
                    cubit.audioEdit();
                  },
                  child: Text(
                    "Discard Changes",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.redColor,
                    ),
                  ),
                ),
              if (state.isAudioEdit == false)
                InkWell(
                  onTap: () {
                    cubit.audioEditDiscard();

                  },
                  child: Text(
                    "Edit Audio",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yellow,
                    ),
                  ),
                ),

              if (state.isAudioEdit)
                InkWell(
                  onTap: () {
                    final path =
                    context.read<AudioPreviewEditCubit>()
                      ..saveTrimmedAudio(audioPath,context);
                    debugPrint("Saved Audio => $path");

                  },
                  child: Text(
                    "Save Audio",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color:AppColors.yellow,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              min: 0,
              max:
                  state.duration.inSeconds.toDouble() == 0
                      ? 1
                      : state.duration.inSeconds.toDouble(),

              value: state.position.inSeconds.toDouble().clamp(
                0,
                state.duration.inSeconds.toDouble() == 0
                    ? 1
                    : state.duration.inSeconds.toDouble(),
              ),

              activeColor: Colors.white,
              inactiveColor: Colors.white24,

              onChanged: (v) {
                cubit.seek(Duration(seconds: v.toInt()));
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        /// ⏱️ Time Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(state.position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _format(state.duration),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// ▶️ Controls Row
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: cubit.changeSpeed,
                child: Text(
                  "${state.speed}x",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 5.width),
              IconButton(
                icon: Image.asset(Images.rotate_ccw, width: 32, height: 32),
                color: Colors.white,
                onPressed: cubit.rewind15,
              ),
              SizedBox(width: 5.width),
              IconButton(
                icon: Icon(
                  state.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 64,
                ),
                color: Colors.white,
                onPressed: cubit.playPause,
              ),
              SizedBox(width: 5.width),
              IconButton(
                icon: Image.asset(Images.rotate_cw, width: 32, height: 32),
                color: Colors.white,
                onPressed: cubit.forward15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ⏱️ Time formatter
  static String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Widget _buildAudioWaveform(AudioPreviewEditState state, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: WaveformView(
                  audioPath: audioPath,
                  state: state,
                  // activeColor: Colors.white,
                  // inactiveColor: Colors.white24,
                ),
                //const AudioWaveformWidget(isPlaying: false, activeColor: Colors.white, inactiveColor: Colors.white,spacingValue: 4.5,width: double.infinity,),
              ),
              const SizedBox(width: 16),
              // Duration
            ],
          ),
        ),
      ],
    );
  }
}
