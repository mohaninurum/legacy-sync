
import 'package:just_audio/just_audio.dart';
import 'package:legacy_sync/features/play_podcast/presentation/bloc/play_podcast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  Future<void> loadAudio(String url) async {
    try {
      await _audioPlayer.setFilePath(url);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

 void bookmark(){
    if(state.isBookmark==true){
      emit(state.copyWith(isBookmark: false));
    }else{
      emit(state.copyWith(isBookmark: true));
    }
 }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
