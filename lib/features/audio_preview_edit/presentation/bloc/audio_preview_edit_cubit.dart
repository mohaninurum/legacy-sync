import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart' as aw;
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/audio_preview_edit/domain/usecases/audio_preview_edit_usecase.dart';
import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';
import 'package:path_provider/path_provider.dart';
import 'audio_preview_edit_state.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class AudioPreviewEditCubit extends Cubit<AudioPreviewEditState> {
  AudioPreviewEditCubit() : super(AudioPreviewEditState.initial()) {
    _bindPlayerStreams();
  }

  final AudioPreviewEditUseCase audioPreviewEditUseCase =
      AudioPreviewEditUseCase();
  final ja.AudioPlayer _player = ja.AudioPlayer();
  final aw.PlayerController _waveController = aw.PlayerController();

  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  late StreamSubscription<ja.PlayerState> _playerStateSub;
  late StreamSubscription<Duration> _posSub;
  late StreamSubscription<ja.PlaybackEvent> _playbackEventSub;

  String? _waveLocalPath; // downloaded local path for waveform extraction
  CancelToken? _downloadCancelToken;

  XFile? _pickedCoverFile;

  aw.PlayerController get playerController => _waveController;

  ja.AudioPlayer get audioController => _player;

  // ---------------------------
  // Public API
  // ---------------------------

  void addCoverXFile(XFile file) {
    _pickedCoverFile = file;
    emit(state.copyWith(coverImage: file.path)); // for UI preview
  }

  Future<void> stopAndReset() async {
    await _cleanupWaveTempFile();

    await _posSub.cancel();
    await _playerStateSub.cancel();
    await _playbackEventSub.cancel();

    // stop players (dispose NOT here)
    try { await _player.stop(); await _player.seek(Duration.zero);} catch (_) {}
    try { await _waveController.stopPlayer(); } catch (_) {}

    // DON'T dispose controllers here
    title.clear();
    description.clear();

    _pickedCoverFile = null;

    emit(AudioPreviewEditState.initial());
  }

  Future<void> setData({required PodcastModel data}) async {
    final audioPath =
        (data.audioPath ?? '').trim(); // must hold audio_url for drafts

    final img = (data.image ?? '').trim();

    final safeCover = (img.startsWith("http://") || img.startsWith("https://"))
        ? img
        : Images.podcast_thumbnail;

    print("Image Comes from draft section :: $img");
    emit(
      state.copyWith(
        coverImage: safeCover,
        title: data.title,
        description: data.description,
        isAudioInitial: false,
        errorMessage: null,
        isBookmark: data.isFavourite == 1,
      ),
    );

    title.text = (data.title ?? '').toString();
    description.text = (data.description ?? '').toString();

    await loadAudio(audioPath);
    await prepareWaveform(audioPath);
  }

  Future<void> loadAudio(String source) async {
    if (source.isEmpty) {
      emit(state.copyWith(errorMessage: "Audio source is empty."));
      return;
    }

    try {
      emit(state.copyWith(isBuffering: true, errorMessage: null));

      // Stop any ongoing playback first
      await _player.stop();

      Duration? dur;

      if (_isNetwork(source)) {
        // URL playback
        dur = await _player.setUrl(source);
      } else if (_isAsset(source)) {
        dur = await _player.setAsset(source);
      } else {
        // local file
        dur = await _player.setFilePath(source);
      }
      await _player.load();

      // await _player.setLoopMode(ja.LoopMode.one);

      final duration = dur ?? _player.duration ?? Duration.zero;

      emit(
        state.copyWith(
          duration: duration,
          trimEnd: duration.inSeconds.toDouble(),
          isAudioInitial: true,
          isBuffering: false,
        ),
      );

      debugPrint("[AudioPreviewEdit] loaded: $source");
      debugPrint("[AudioPreviewEdit] duration: $duration");
    } catch (e, st) {
      debugPrint("[AudioPreviewEdit] loadAudio error: $e\n$st");
      emit(
        state.copyWith(
          isAudioInitial: false,
          isBuffering: false,
          errorMessage: "Failed to load audio. Please try again.",
        ),
      );
    }
  }

  /// Production play/pause that waits for ready state.
  Future<void> playPause() async {
    try {
      if (!state.isAudioInitial) return;

      // If completed, rewind
      if (state.position >= state.duration && state.duration > Duration.zero) {
        await _player.seek(Duration.zero);
      }

      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }

      emit(state.copyWith(isPlaying: _player.playing));
    } catch (e, st) {
      debugPrint("[AudioPreviewEdit] playPause error: $e\n$st");
      emit(state.copyWith(errorMessage: "Playback failed. Please try again."));
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (_) {}
  }

  Future<void> changeSpeed() async {
    final speeds = [1.0, 1.5, 2.0];
    final next = speeds[(speeds.indexOf(state.speed) + 1) % speeds.length];
    try {
      await _player.setSpeed(next);
      emit(state.copyWith(speed: next));
    } catch (_) {}
  }

  Future<void> rewind15() async {
    final newPosition = state.position - const Duration(seconds: 15);
    await seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> forward15() async {
    final maxDuration = state.duration;
    final newPosition = state.position + const Duration(seconds: 15);
    await seek(newPosition > maxDuration ? maxDuration : newPosition);
  }

  void updateTrim(double start, double end) {
    emit(state.copyWith(trimStart: start, trimEnd: end));
  }

  Future<void> markFavourite({required int podcastId}) async {
    emit(state.copyWith(markFavStatus: MarkFavStatus.loading));
    try {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      Map<String, dynamic> body = {
        "user_id": userId,
        "podcast_id": podcastId,
      };
      final response = await audioPreviewEditUseCase.markFavouritePodcast(body);
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
      final response = await audioPreviewEditUseCase.markUnFavouritePodcast(body);
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

  // ---------------------------
  // Waveform (URL -> download -> prepare)
  // ---------------------------

  Future<void> prepareWaveform(String source) async {
    // If it's an asset or local file, prepare directly.
    // If it's a URL, download first.
    try {
      // clean any previous waveform file
      emit(state.copyWith(waveDownloadProgress: 0.0, isWaveLoading: true));
      await _cleanupWaveTempFile();

      if (source.isEmpty) return;

      String localPath;

      if (_isNetwork(source)) {
        localPath = await _downloadToTemp(source);

        // Keep it to cleanup later
        _waveLocalPath = localPath;
      } else if (_isAsset(source)) {
        // audio_waveforms can't read assets directly; copy asset to temp
        localPath = await _copyAssetToTemp(source);
        _waveLocalPath = localPath;
      } else {
        localPath = source;
        _waveLocalPath = null; // it's a real local file from your app
      }

      await _waveController.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
        noOfSamples: 120,
      );

      emit(state.copyWith(isWaveLoading: false));
    } catch (e, st) {
      debugPrint("[AudioPreviewEdit] prepareWaveform error: $e\n$st");
      // waveform is optional; don't break playback
      emit(state.copyWith(isWaveLoading: false));
    }
  }

  Future<String> _downloadToTemp(String url) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: true,
      ),
    );

    _downloadCancelToken?.cancel();
    _downloadCancelToken = CancelToken();

    final tempDir = await getTemporaryDirectory();
    final fileName = _safeFileNameFromUrl(url);
    final file = File('${tempDir.path}/ls_wave_$fileName');

    // simple cache: if already exists and not tiny, reuse
    if (await file.exists()) {
      final len = await file.length();
      if (len > 50 * 1024) {
        return file.path;
      }
    }

    await dio.download(
      url,
      file.path,
      cancelToken: _downloadCancelToken,
      options: Options(
        responseType: ResponseType.bytes,
        // Range support improves streaming/caching reliability on some servers
        headers: {"Accept": "*/*"},
      ),
      onReceiveProgress: (received, total) {
        if (total > 0) {
          final progress = received / total;
          emit(state.copyWith(waveDownloadProgress: progress.clamp(0, 1)));
        }
      },
    );

    return file.path;
  }

  Future<String> _copyAssetToTemp(String assetPath) async {
    // assetPath looks like: assets/audio/sample.mp3
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final hash = md5.convert(bytes).toString();
    final ext = assetPath.split('.').last;
    final file = File('${tempDir.path}/ls_asset_$hash.$ext');

    if (!await file.exists()) {
      await file.writeAsBytes(bytes, flush: true);
    }

    return file.path;
  }

  String _safeFileNameFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final last =
        uri?.pathSegments.isNotEmpty == true ? uri!.pathSegments.last : "audio";
    final clean = last.replaceAll(RegExp(r'[^a-zA-Z0-9\._-]'), '_');
    // ensure unique stable name
    final hash = md5.convert(url.codeUnits).toString().substring(0, 10);
    final ext = clean.contains('.') ? clean.split('.').last : "bin";
    return "${clean.split('.').first}_$hash.$ext";
  }

  Future<void> _cleanupWaveTempFile() async {
    _downloadCancelToken?.cancel();
    _downloadCancelToken = null;

    if (_waveLocalPath == null) return;

    try {
      final f = File(_waveLocalPath!);
      if (await f.exists()) {
        await f.delete();
      }
    } catch (_) {}
    _waveLocalPath = null;

    // reset progress
    emit(state.copyWith(waveDownloadProgress: 0));
  }

  // ---------------------------
  // Draft upload thumbnail (kept from your code)
  // ---------------------------

  Future<Uint8List> getDraftThumbnailBytes() async {
    Uint8List bytes;

    if (_pickedCoverFile != null) {
      bytes = await _pickedCoverFile!.readAsBytes();
    } else {
      final data = await rootBundle.load('assets/images/podcast_thumbnail.png');
      bytes = data.buffer.asUint8List();
    }

    final compressed = await _compressImageBytes(bytes);
    return compressed ?? bytes;
  }

  Future<Uint8List?> _compressImageBytes(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 512,
      minHeight: 512,
      quality: 70,
      format: CompressFormat.jpeg,
    );
    return Uint8List.fromList(result);
  }

  Future<void> publishPodcast({required int podcastId, required int durationSeconds}) async {
    emit(
      state.copyWith(
        publishStatus: PublishStatus.loading,
        publishMessage: null,
      ),
    );

    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

    final fields = <String, String>{
      "user_id": userId.toString(),
      "title": title.text.trim(),
      "description": description.text.trim(),
      "podcast_id": podcastId.toString(),
      "duration_seconds": durationSeconds.toString()
      // backend expects thumb_nail as file, so no need to send "" here
    };

    try {
      final thumbBytes = await getDraftThumbnailBytes();
      final res = await audioPreviewEditUseCase.publishPodcast(
        fields: fields,
        thumbnailBytes: thumbBytes, // can be null if you want to allow no thumb
        thumbnailFileName: "thumb_${DateTime.now().millisecondsSinceEpoch}.png",
        thumbnailKey: "thumb_nail",
      );

      res.fold(
        (error) {
          emit(
            state.copyWith(
              publishStatus: PublishStatus.failure,
              publishMessage: error.message ?? "Publish failed",
            ),
          );
          _pickedCoverFile = null;
        },
        (data) {
          emit(
            state.copyWith(
              publishStatus:
                  data.status == true
                      ? PublishStatus.success
                      : PublishStatus.failure,
              publishMessage:
                  data.message ??
                  (data.status == true ? "Published" : "Publish failed"),
            ),
          );
          _pickedCoverFile = null;
        },
      );
    } catch (e) {
      debugPrint("Publish failed. Please try again error : ${e.toString()}");
      emit(
        state.copyWith(
          publishStatus: PublishStatus.failure,
          publishMessage: "Publish failed. Please try again.",
        ),
      );
    }
  }
  String? _roomId;

  void setRoomId(String? roomId) {
    _roomId = (roomId ?? '').trim().isEmpty ? null : roomId!.trim();
  }

  bool _validateDraft({bool showToast = false, String? roomId, int? userId, String? topicCovered}) {
    final t = title.text.trim();
    if (t.isEmpty) {
      if (showToast) {
        BotToast.showText(text: "Please enter a title.");
      }
      return false;
    }
    if (roomId == null) {
      if (showToast) {
        BotToast.showText(text: "RoomId missing. Please try again.");
      }
      return false;
    }
    if (userId == null) {
      if (showToast) {
        BotToast.showText(text: "User Id Missing. Please login again.");
      }
    }
    if (topicCovered == null || topicCovered.isEmpty) {
      if (showToast) {
        BotToast.showText(text: "Covered Topic Is Missing. Please try again.");
      }
    }
    return true;
  }

  Future<void> saveAsDraft({required String roomId, required String topicType}) async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final topicCovered = topicType;
    if (!_validateDraft(showToast: true, roomId: roomId, userId: userId, topicCovered: topicCovered)) return;
    emit(state.copyWith(saveAsDraftStatus: SaveAsDraftStatus.loading,draftMessage: null));

    final fields = <String, String>{
      "user_id": userId.toString(),
      "title": title.text.trim(),
      "description": description.text.trim(),
      "livekit_room_id": _roomId!,
      "topic_type": topicCovered,
      // backend expects thumb_nail as file, so no need to send "" here
    };

    try {
      final thumbBytes = await getDraftThumbnailBytes();
      final res = await audioPreviewEditUseCase.saveAsDraftMultipart(
        fields: fields,
        thumbnailBytes: thumbBytes, // can be null if you want to allow no thumb
        thumbnailFileName: "thumb_${DateTime.now().millisecondsSinceEpoch}.png",
        thumbnailKey: "thumb_nail", // must match backend key
      );
      res.fold(
        (error) {
          emit(state.copyWith(saveAsDraftStatus: SaveAsDraftStatus.failure,  draftMessage: error.message ?? "Save as draft failed", ));
        },
        (data) async {
          emit(state.copyWith(saveAsDraftStatus: SaveAsDraftStatus.success, publishMessage:
          data.message ??
              (data.status == true ? "Saved" : "Draft failed"),));
          _pickedCoverFile = null;
        },
      );
    } catch (e) {
      debugPrint("[AudioPreviewEdit] saveAsDraft error: $e");
      emit(state.copyWith(saveAsDraftStatus: SaveAsDraftStatus.failure, draftMessage: "Save as draft failed. Please try again."));
    }
  }

  // ---------------------------
  // Internals
  // ---------------------------

  void _bindPlayerStreams() {
    _posSub = _player.positionStream.listen((pos) {
      emit(state.copyWith(position: pos));
    });

    _playerStateSub = _player.playerStateStream.listen((ja.PlayerState ps) {
      final buffering =
          ps.processingState == ja.ProcessingState.loading ||
          ps.processingState == ja.ProcessingState.buffering;

      emit(state.copyWith(isBuffering: buffering, isPlaying: _player.playing));

      if (ps.processingState == ja.ProcessingState.completed) {
        emit(state.copyWith(isPlaying: false));
      }
    });

    _playbackEventSub = _player.playbackEventStream.listen(
      (_) {},
      onError: (e, st) {
        debugPrint("[AudioPreviewEdit] playbackEvent error: $e\n$st");
        emit(state.copyWith(errorMessage: "Audio playback error."));
      },
    );
  }

  bool _isNetwork(String s) =>
      s.startsWith("http://") || s.startsWith("https://");

  bool _isAsset(String s) => s.startsWith("assets/");

  @override
  Future<void> close() async {
    await _cleanupWaveTempFile();

    await _posSub.cancel();
    await _playerStateSub.cancel();
    await _playbackEventSub.cancel();

    title.dispose();
    description.dispose();

    await _player.dispose();
    _waveController.dispose();

    return super.close();
  }

  /// 🎯 REAL AUDIO TRIM (Second Screenshot)
  Future<String> saveTrimmedAudio(
    String inputPath,
    BuildContext context,
  ) async {
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

    emit(state.copyWith(isAudioEdit: false, trimAudioPath: output));
    // loadAudio(output);
    title.clear();
    description.clear();

    return output;
  }

  void onStartTrimSecond(double onStartSecond) {
    emit(state.copyWith(trimStart: onStartSecond));
  }

  void onEndTrimSecond(double onEndSecond) {
    emit(state.copyWith(trimEnd: onEndSecond));
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
}
