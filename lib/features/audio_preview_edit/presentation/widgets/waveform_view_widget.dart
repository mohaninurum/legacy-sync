import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../bloc/audio_preview_edit_cubit.dart';
import '../bloc/audio_preview_edit_state.dart';

class WaveformView extends StatelessWidget {
  final String audioPath;
  final AudioPreviewEditState state;

  const WaveformView({super.key, required this.audioPath, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioPreviewEditCubit>();
    return AudioFileWaveforms(

      size: const Size(double.infinity, 120),
      playerController: cubit.playerController,
      enableSeekGesture: true,
      waveformType: WaveformType.long,
      animationDuration: const Duration(milliseconds: 300),
      continuousWaveform: true,
      playerWaveStyle:  const PlayerWaveStyle(
        fixedWaveColor: Colors.white38,
        liveWaveColor: Colors.white,
        spacing: 4.5,
      ),

      onDragStart: (_) {
        debugPrint("Waveform drag start");
      },

      onDragEnd: (_) {
        debugPrint("Waveform drag end");
      },
    );
  }
}
