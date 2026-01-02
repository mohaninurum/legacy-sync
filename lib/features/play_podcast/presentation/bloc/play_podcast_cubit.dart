
import 'package:just_audio/just_audio.dart';
import 'package:legacy_sync/features/play_podcast/presentation/bloc/play_podcast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../audio_overlay_manager/audio_overlay_manager.dart';
import '../../../my_podcast/data/podcast_model.dart';

class PlayPodcastCubit extends Cubit<PlayPodcastState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlayPodcastCubit() : super(PlayPodcastState.initial()) {
    _init();
  }

  void _init() {
    _audioPlayer.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        emit(state.copyWith(duration: duration));
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) {
      emit(state.copyWith(isPlaying: playerState.playing));
    });

    // _audioPlayer.positionStream.listen((pos) {
    //   final currentSegment = segments.firstWhere(
    //         (s) => pos.inMilliseconds / 1000 >= s.start,
    //   );
    //   // Highlight that text
    // });
  }

  Future<void> loadAudio(String url,  PodcastModel? podcast) async {
    try {
      emit(state.copyWith(podcast: podcast));
      await _audioPlayer.setAsset(url);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void audioPlay() {
    if (state.isPlaying) {
      emit(state.copyWith(isPlaying: false));
    } else {
    }
  }

  void playPauseOvalayManger() {
    if (state.position >= state.duration) {
      _audioPlayer.seek(Duration.zero);
    }

    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      emit(state.copyWith(isPlaying: false));
      AudioOverlayManager.updatePlaying(false);
    } else {
      _audioPlayer.play();
      emit(state.copyWith(isPlaying: true));
      AudioOverlayManager.updatePlaying(true);
    }
  }


  void playPause() {
    // 1️⃣ If audio completed → reset
    // if (state.position >= state.duration) {
    //   _audioPlayer.seek(Duration.zero);
    // }
    //
    // if (_audioPlayer.playing) {
    //   _audioPlayer.pause();
    // } else {
    //   _audioPlayer.play();
    // }
    //
    // emit(state.copyWith(isPlaying: _audioPlayer.playing));

    if (state.position >= state.duration) {
      _audioPlayer.seek(Duration.zero);
    }

    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      emit(state.copyWith(isPlaying: false));
      AudioOverlayManager.updatePlaying(false);
    } else {
      _audioPlayer.play();
      emit(state.copyWith(isPlaying: true));
      AudioOverlayManager.updatePlaying(true);
    }
  }


  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void changeSpeed() {
    final speeds = [1.0, 1.5, 2.0];
    final next = speeds[(speeds.indexOf(state.speed) + 1) % speeds.length];
    _audioPlayer.setSpeed(next);
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






  void bookmark(){
    if(state.isBookmark==true){
      emit(state.copyWith(isBookmark: false));
    }else{
      emit(state.copyWith(isBookmark: true));
    }
 }
 void isScrollController(bool isScroll){
      emit(state.copyWith(isScroll: isScroll));
 }


 void loadOverlayAudioManager(bool value) {
   emit(state.copyWith(isOverlayManager: value));
  }



  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
