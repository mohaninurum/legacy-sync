import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:legacy_sync/features/my_podcast/presentation/bloc/my_podcast_cubit.dart';
import 'package:legacy_sync/features/play_podcast/presentation/bloc/play_podcast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/db/shared_preferences.dart';
import '../../../../core/utils/utils.dart';
import '../../../audio_overlay_manager/audio_overlay_manager.dart';
import '../../../my_podcast/data/podcast_model.dart';
import '../../domain/usecase_play_podcast/usecase_play_podcast.dart';

class PlayPodcastCubit extends Cubit<PlayPodcastState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  UseCasePlayPodcast useCasePlayPodcast = UseCasePlayPodcast();
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

  Future<void> loadAudio(String url, PodcastModel podcast,isContinue) async {
    Utils.showLoader();
    try {
      emit(state.copyWith(podcast: podcast,
      isBookmark: podcast.isFavourite == 1));
      await _audioPlayer.setUrl(url);
      if (isContinue) {
        _audioPlayer.seek(Duration(seconds: podcast.listenedSec));
      }
    } catch (e) {
      print('Error loading audio: $e');
    }
    Utils.closeLoader();
  }

  void audioPlay() {
    if (state.isPlaying) {
      emit(state.copyWith(isPlaying: false));
    } else {}
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

    seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void forward15() {
    final maxDuration = state.duration;
    final newPosition = state.position + const Duration(seconds: 15);

    seek(newPosition > maxDuration ? maxDuration : newPosition);
  }

  void isScrollController(bool isScroll) {
    emit(state.copyWith(isScroll: isScroll));
  }

  void loadOverlayAudioManager(bool value) {
    emit(state.copyWith(isOverlayManager: value));
  }

  /// continue listing post  //podcast/save-listened-podcast-time

  Future<void> markFavourite({required int podcastId}) async {
    emit(state.copyWith(markFavStatus: MarkFavStatus.loading));
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      Map<String, dynamic> body = {
        "user_id": userId,
        "podcast_id": podcastId,
      };
      final response = await useCasePlayPodcast.markFavouritePodcast(body);
      response.fold((error) {
        emit(state.copyWith(markFavMessage: error.message ?? "Failed to add favourites", markFavStatus: MarkFavStatus.failure));
      }, (result) {
        emit(state.copyWith(isBookmark: true, markFavStatus: MarkFavStatus.success, markFavMessage: result.message));
      },);
    } catch (e) {
      debugPrint("Error :: ${e.toString()}");
      emit(state.copyWith(markFavMessage: e.toString(), markFavStatus: MarkFavStatus.initial));
    }
  }

  Future<void> markUnFavourite({required int podcastId}) async {
    emit(state.copyWith(markUnFavStatus: MarkUnFavStatus.loading));
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      Map<String, dynamic> body = {
        "user_id": userId,
        "podcast_id": podcastId,
      };
      final response = await useCasePlayPodcast.markUnFavouritePodcast(body);
      response.fold((error) {
        emit(state.copyWith(markUnFavMessage: error.message, markUnFavStatus: MarkUnFavStatus.failure));
      }, (result) {
        emit(state.copyWith(markUnFavMessage: result.message, isBookmark: false, markUnFavStatus: MarkUnFavStatus.success));
      },);
    } catch (e) {
      debugPrint("Error :: ${e.toString()}");
      emit(state.copyWith(markUnFavMessage: e.toString(), markUnFavStatus: MarkUnFavStatus.initial));
    }
  }

  Future<void> saveListenedPodcastTime(
    int podcastId,
  ) async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    Map<String, dynamic> body = {
      "user_id": userId,
      "podcast_id": podcastId,
      "listened_seconds": state.position.inSeconds,
    };
    if(state.duration.inSeconds>=8){
      final myPodCast = await useCasePlayPodcast.saveListenedPodcastTime(body);
      myPodCast.fold(
        (error) {
          print("APP EXCEPTION:: ${error.message}");
          Utils.closeLoader();
        },
        (result) {
          Utils.closeLoader();
        },
      );
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
