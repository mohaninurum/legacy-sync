import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/show_success_dialog.dart';
import 'audio_preview_edit_state.dart';

class AudioPreviewEditCubit extends Cubit<AudioPreviewEditState> {
  final AudioPlayer _player = AudioPlayer();

  final PlayerController _playerController = PlayerController();
  TextEditingController title=TextEditingController();
  TextEditingController description=TextEditingController();
  PlayerController get playerController => _playerController;
  AudioPlayer get audioController => _player;

  AudioPreviewEditCubit() : super(AudioPreviewEditState.initial()) {
    _player.positionStream.listen((pos) {
      emit(state.copyWith(position: pos));
    });
  }

  Future<void> loadAudio(String path,bool isDraft) async {
    await _player.setAsset(path);
    if(isDraft){
      loadMetadata();
    }
    emit(
      state.copyWith(
        duration: _player.duration ?? Duration.zero,
        trimEnd: _player.duration?.inSeconds.toDouble() ?? 0,
          isAudioInitial:true
      ),
    );
  }

  void loadMetadata(){
    title.text="Add Conversations That Stay";
    description.text="A heartfelt exchange about love, family, and lessons that last.";
  }


  Future<void> audioWavesLoad(String path) async {
    await playerController.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
    );
  }

  void audioPlay() {
    if (state.isPlaying) {
      _playerController.stopPlayer();
      emit(state.copyWith(isPlaying: false));
    } else {
      _playerController.startPlayer();
    }
  }

  void dispose() {
    playerController.dispose();
  }

  void playPause() {
    // 1️⃣ If audio completed → reset
    if (state.position >= state.duration) {
      _player.seek(Duration.zero);
      _playerController.seekTo(0);
    }

    if (_player.playing) {
      _player.pause();
      _playerController.stopPlayer();
    } else {
      _player.play();
      _playerController.startPlayer();
    }

    emit(state.copyWith(isPlaying: _player.playing));
  }


  void seek(Duration position) {
    _player.seek(position);
  }

  void changeSpeed() {
    final speeds = [1.0, 1.5, 2.0];
    final next = speeds[(speeds.indexOf(state.speed) + 1) % speeds.length];
    _player.setSpeed(next);
    emit(state.copyWith(speed: next));
  }

  void rewind15() {
    final newPosition = state.position - const Duration(seconds: 15);

    seek(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void forward15() {
    final maxDuration = state.duration;
    final newPosition = state.position + const Duration(seconds: 15);

    seek(
      newPosition > maxDuration ? maxDuration : newPosition,
    );
  }


  void updateTrim(double start, double end) {
    emit(state.copyWith(trimStart: start, trimEnd: end));
  }

  /// 🎯 REAL AUDIO TRIM (Second Screenshot)
  Future<String> saveTrimmedAudio(String inputPath,BuildContext context) async {
    final output =
        '${Directory.systemTemp.path}/trimmed_${DateTime.now().millisecondsSinceEpoch}.mp3';
   print(output);
   print("trim:-${state.trimStart} -to ${state.trimEnd}");
    // await FFmpegKit.execute(
    //   '-i $inputPath -ss ${state.trimStart} -to ${state.trimEnd} -c copy $output',
    // );
    print("path...");
    print(output);
    print("meta data:-${title.text} -to ${description.text}");

    emit(state.copyWith(isAudioEdit: false,trimAudioPath: output));
    // loadAudio(output);
    title.clear();
    description.clear();

    return output;
  }



  Future<String> save(String inputPath,BuildContext context) async {
    ShowSuccessDialog.showSuccessDialog(context);
    title.clear();
    description.clear();
    ShowSuccessDialog.showSuccessDialog(context);
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
    return "";
  }

  void onStartTrimSecond(double onStartSecond) {
    emit(state.copyWith(trimStart: onStartSecond));
  }
  void onEndTrimSecond(double onEndSecond) {
    emit(state.copyWith(trimEnd: onEndSecond));
  }


  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }

  void addCover(String path) {
    emit(state.copyWith(coverImage: path));
  }

  void bookmark() {
    if (state.isBookmark == true) {
      emit(state.copyWith(isBookmark: false));
    } else {
      emit(state.copyWith(isBookmark: true));
    }
  }

  audioEdit() {
    if (state.isAudioEdit == true) {
      emit(state.copyWith(isAudioEdit: false));
    } else {
      emit(state.copyWith(isAudioEdit: true));
    }
  }
  audioEditDiscard() {
    if (state.isAudioEdit == true) {
      emit(state.copyWith(isAudioEdit: false));
    } else {
      emit(state.copyWith(isAudioEdit: true));
    }
  }
  audioEditSave() {
    if (state.isAudioEdit == true) {
      emit(state.copyWith(isAudioEdit: false));
    } else {
      emit(state.copyWith(isAudioEdit: true));
    }
  }



  void listenAudioComplete() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero); // 🔁 start se lao
        _player.play();              // ▶️ phir play karo

        emit(
          this.state.copyWith(
            position: Duration.zero,
            isPlaying: true,
          ),
        );
      }
    });
  }





}
