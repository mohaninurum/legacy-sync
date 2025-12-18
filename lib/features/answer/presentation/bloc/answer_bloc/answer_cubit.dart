import 'dart:io';
import 'dart:async';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/answer/domain/usecases/answare_usecase.dart';
import 'package:legacy_sync/features/list_of_module/presentation/bloc/list_of_module_bloc/list_of_module_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:legacy_sync/features/answer/presentation/bloc/answer_state/answer_state.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../../../../config/routes/routes_name.dart';
import '../../../../../core/components/comman_components/congratulations_module_dialog.dart';


class AnswerCubit extends Cubit<AnswerState> {

  AnswerCubit() : super(AnswerState.initial());
  List<CameraDescription> _cameras = [];
  AnswerUseCase answerUseCase = AnswerUseCase();
  final FlutterTts flutterTts = FlutterTts();

  // Camera controller
  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

  // Audio recording
  final RecorderController _recorderController = RecorderController();

  RecorderController get recorderController => _recorderController;

  // Audio player
  final PlayerController _playerController = PlayerController();

  PlayerController get playerController => _playerController;
  String? _currentRecordingPath;

  // Speech recognition
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // Timer for recording duration
  Timer? _recordingTimer;




  @override
  Future<void> close() async {
    await flutterTts.stop();
    _cameraController?.dispose();
    _recorderController.dispose();
    _playerController.dispose();
    _recordingTimer?.cancel();
    return super.close();
  }
  void initialState() {
    emit(AnswerState.initial());
  }


  Future<void> initializeCamera() async {
    try {

      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(cameras.first, ResolutionPreset.high, enableAudio: true);
        await _cameraController!.initialize();
        await cameraController?.setFocusMode(FocusMode.auto);
        if(state.zoom==1.0){
          loadZoomLimits();
        }else{
          setZoom( state.zoom);
        }

      }
    } catch (e) {
      print("Camera initialization error: $e");
    }
  }

  Future<void> requestPermissions() async {
    try {
      final micStatus = await Permission.microphone.request();
      final cameraStatus = await Permission.camera.request();

      if (micStatus.isGranted && cameraStatus.isGranted) {
        emit(state.copyWith(permissionsGranted: true));

        // Initialize speech recognition
        _speechEnabled = await _speechToText.initialize();
        if (kDebugMode) {
          print("Speech recognition initialized: $_speechEnabled");
        }

        // Check if speech recognition is available
        if (_speechEnabled) {
          if (kDebugMode) {
            print("Speech recognition is available and ready");
          }
        } else {
          if (kDebugMode) {
            print("Speech recognition failed to initialize");
          }
        }

        // Initialize camera
        await initializeCamera();
      } else {
        emit(state.copyWith(permissionsGranted: false));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Permission request error: $e");
      }
    }
  }

  Future<void> startVoiceRecording() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus.isDenied || micStatus.isPermanentlyDenied || micStatus.isRestricted) {
      return;
    }
    try {
      // Debug speech recognition status
      debugSpeechRecognition();
      emit(state.copyWith(isAudioExist: true));
      print("IS Audio Exist:-${state.isAudioExist}");
      if (!_recorderController.hasPermission) {
        await _recorderController.checkPermission();
        if (!_recorderController.hasPermission) return;
      }

      // Get recording path
      final directory = await getTemporaryDirectory();
      _currentRecordingPath = '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await _recorderController.record(path: _currentRecordingPath);

      // Start speech recognition
      print("Speech recognition status: $_speechEnabled");
      if (_speechEnabled) {
        try {
          await _speechToText.listen(
            onResult: (result) {
              print("Speech recognition result: ${result.recognizedWords}");
              if (result.recognizedWords.isNotEmpty) {
                final newText = state.transcribedText.isEmpty ? result.recognizedWords : '${state.transcribedText} ${result.recognizedWords}';
                print("Updated transcribed text: $newText");
                emit(state.copyWith(transcribedText: newText));
              }
            },
          );
          print("Speech recognition started successfully");
        } catch (e) {
          print("Error starting speech recognition: $e");
          // Try to re-initialize speech recognition
          try {
            _speechEnabled = await _speechToText.initialize();
            print("Re-initialized speech recognition: $_speechEnabled");
            if (_speechEnabled) {
              await _speechToText.listen(
                onResult: (result) {
                  print("Speech recognition result (retry): ${result.recognizedWords}");
                  if (result.recognizedWords.isNotEmpty) {
                    final newText = state.transcribedText.isEmpty ? result.recognizedWords : '${state.transcribedText} ${result.recognizedWords}';
                    print("Updated transcribed text (retry): $newText");
                    emit(state.copyWith(transcribedText: newText));
                  }
                },
              );
              print("Speech recognition started successfully after retry");
            }
          } catch (retryError) {
            print("Failed to re-initialize speech recognition: $retryError");
          }
        }
      } else {
        print("Speech recognition not enabled");
      }

      // Start recording timer
      _startRecordingTimer();

      // Listen to waveform data
      _recorderController.onCurrentDuration.listen((duration) {
        // Update recording duration
        emit(state.copyWith(recordingDuration: duration));
      });

      emit(state.copyWith(recordingType: RecordingType.voice, recordingState: RecordingState.recording, startTime: DateTime.now(),isAudioExist: true));

      print("Voice recording started");
    } catch (e) {
      print("Voice recording error: $e");
    }
  }

  // Start recording timer
  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.recordingState == RecordingState.recording) {
        emit(state.copyWith(recordingDuration: state.recordingDuration + const Duration(seconds: 1)));
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> pauseVoiceRecording() async {
    try {
      await _recorderController.pause();
      await _speechToText.stop();

      // Pause the timer
      _recordingTimer?.cancel();

      emit(state.copyWith(recordingState: RecordingState.paused));

      print("Voice recording paused");
    } catch (e) {
      print("Voice recording pause error: $e");
    }
  }

  Future<void> resumeVoiceRecording() async {
    try {
      await _recorderController.record(path: _currentRecordingPath);

      if (_speechEnabled) {
        try {
          await _speechToText.listen(
            onResult: (result) {
              print("Speech recognition result (resume): ${result.recognizedWords}");
              if (result.recognizedWords.isNotEmpty) {
                final newText = state.transcribedText.isEmpty ? result.recognizedWords : '${state.transcribedText} ${result.recognizedWords}';
                print("Updated transcribed text (resume): $newText");
                emit(state.copyWith(transcribedText: newText));
              }
            },
          );
          print("Speech recognition resumed successfully");
        } catch (e) {
          print("Error resuming speech recognition: $e");
        }
      }

      // Resume the timer
      _startRecordingTimer();

      emit(state.copyWith(recordingState: RecordingState.recording,isAudioExist: true));

      print("Voice recording resumed");
    } catch (e) {
      print("Voice recording resume error: $e");
    }
  }

  Future<void> stopVoiceRecording() async {
    try {
      final recordedPath = await _recorderController.stop();
      await _speechToText.stop();

      // Stop the timer
      _recordingTimer?.cancel();

      if (recordedPath != null) {
        _currentRecordingPath = recordedPath;
      }

      emit(state.copyWith(recordingState: RecordingState.completed, endTime: DateTime.now()));

      print("Voice recording stopped");
    } catch (e) {
      print("Voice recording stop error: $e");
    }
  }

  Future<void> playRecordedAudio() async {
    try {
      print("Attempting to play recorded audio...");
      print("Current recording path: $_currentRecordingPath");

      if (_currentRecordingPath != null && File(_currentRecordingPath!).existsSync()) {
        print("Audio file exists, preparing player...");

        // Stop any current playback first
        try {
          await _playerController.stopPlayer();
        } catch (e) {
          print("Error stopping previous playback: $e");
        }
        // Reset the player controller to clear its state
        try {
          // Try to seek to beginning if possible
          try {
            await _playerController.seekTo(0);
          } catch (e) {
            print("Could not seek to beginning: $e");
          }
        } catch (e) {
          print("Error resetting player: $e");
        }

        // Prepare the player controller for waveform visualization
        await _playerController.preparePlayer(path: _currentRecordingPath!, shouldExtractWaveform: true);
        print("Player prepared successfully");

        // Start playing
        await _playerController.startPlayer();
        print("Player started successfully");
        emit(state.copyWith(isAudioPlaying: true));
        // Listen for completion
        _playerController.onCompletion.listen((_) {
          print("Audio playback completed");
          emit(state.copyWith(isAudioPlaying: false));
        });
      } else {
        print("Audio file not found or path is null: $_currentRecordingPath");
        if (_currentRecordingPath != null) {
          print("File exists check: ${File(_currentRecordingPath!).existsSync()}");
        }
      }
    } catch (e) {
      print("Audio playback error: $e");
      // Reset the playing state on error
      emit(state.copyWith(isAudioPlaying: false));
    }
  }

  Future<void> stopAudioPlayback() async {
    try {
      print("Stopping audio playback...");
      await _playerController.stopPlayer();
      emit(state.copyWith(isAudioPlaying: false));
      print("Audio playback stopped successfully");
    } catch (e) {
      print("Audio stop error: $e");
      // Reset the playing state on error
      emit(state.copyWith(isAudioPlaying: false));
    }
  }

  void showVideoView() async{
    await initializeCamera();

    final directory = await getTemporaryDirectory();
    final videoPath = '${directory.path}/video_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';
    emit(
      state.copyWith(
        recordingType: RecordingType.video,
        recordingState: RecordingState.paused,
        startTime: DateTime.now(),
        videoPath: videoPath,
        hasStartedRecording: false,
      ),
    );
  }

  Future<void> startVideoRecording() async {
    final micStatus = await Permission.camera.request();
    if (micStatus.isDenied || micStatus.isPermanentlyDenied || micStatus.isRestricted) {
      return;
    }
    await initializeCamera();
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final directory = await getTemporaryDirectory();
        final videoPath = '${directory.path}/video_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';
        await _cameraController!.startVideoRecording();
        // Start recording timer for video
        _startRecordingTimer();

        emit(state.copyWith(recordingType: RecordingType.video, recordingState: RecordingState.recording, startTime: DateTime.now(), videoPath: videoPath,isVideoExist: true,  hasStartedRecording: false, ));
        // pauseVideoRecording();
      }
    } catch (e) {
      print("Video recording error: $e");
    }
  }

  Future<void> pauseVideoRecording() async {
    try {
      if (_cameraController != null && _cameraController!.value.isRecordingVideo) {

        await _cameraController!.pauseVideoRecording();
        _recordingTimer?.cancel();
        emit(state.copyWith(recordingState: RecordingState.paused));
        print("Video recording paused");
      }
    } catch (e) {
      print("Video pause error: $e");
    }
  }

  Future<void> resumeVideoRecording() async {

    try {

      if (_cameraController != null && state.recordingState == RecordingState.paused) {
        await cameraController?.setFocusMode(FocusMode.auto);
        await _cameraController!.resumeVideoRecording();
        _startRecordingTimer();
        emit(state.copyWith(recordingState: RecordingState.recording,isVideoExist: true));
        print("Video recording resumed");
      }
    } catch (e) {
      print("Video resume error: $e");
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      if (_cameraController != null) {
        final videoFile = await _cameraController!.stopVideoRecording();
        _recordingTimer?.cancel();
        String? finalSegmentPath;
        if(state.isFrontCamera){
          emit(state.copyWith(isVideoProcess:true));
          finalSegmentPath = await removeMirrorInBackground(videoFile.path);
        }
        // Stop the timer

        emit(state.copyWith(isFrontCamera:false,isVideoProcess:false,recordingState: RecordingState.completed, endTime: DateTime.now(), videoPath: state.isFrontCamera? finalSegmentPath:videoFile.path));
      }
    } catch (e) {
      print("Video recording stop error: $e");
    }
  }

  void playVideoPreview() {
    if (state.recordingType == RecordingType.video && state.recordingState == RecordingState.completed) {
      emit(state.copyWith(isVideoPlaying: true));
      print("Video preview playing");
    }
  }

  void pauseVideoPreview() {
    if (state.recordingType == RecordingType.video && state.recordingState == RecordingState.completed) {
      emit(state.copyWith(isVideoPlaying: false));
      print("Video preview paused");
    }
  }

  void retakeRecording() {
    // Cancel any active timer
    _recordingTimer?.cancel();
    emit(AnswerState.initial());
    _currentRecordingPath = null;
  }

  bool isAudioReadyForPlayback() {
    final hasPath = _currentRecordingPath != null;
    final fileExists = hasPath ? File(_currentRecordingPath!).existsSync() : false;
    return hasPath && fileExists;
  }

  // Debug method to check speech recognition status
  void debugSpeechRecognition() {
    print("=== Speech Recognition Debug ===");
    print("Speech enabled: $_speechEnabled");
    print("Speech available: ${_speechToText.isAvailable}");
    print("Speech listening: ${_speechToText.isListening}");
    print("Current transcribed text: ${state.transcribedText}");
    print("Permissions granted: ${state.permissionsGranted}");
    print("================================");
  }

  // Test speech recognition manually
  Future<void> testSpeechRecognition() async {
    try {
      print("Testing speech recognition...");
      if (await _speechToText.initialize()) {
        print("Speech recognition initialized for test");
        await _speechToText.listen(
          onResult: (result) {
            print("Test speech recognition result: ${result.recognizedWords}");
            if (result.recognizedWords.isNotEmpty) {
              emit(state.copyWith(transcribedText: result.recognizedWords));
              print("Test transcribed text updated: ${result.recognizedWords}");
            }
          },
        );
        print("Test speech recognition started");
      } else {
        print("Failed to initialize speech recognition for test");
      }
    } catch (e) {
      print("Error testing speech recognition: $e");
    }
  }

  // Force re-initialize speech recognition
  Future<void> reinitializeSpeechRecognition() async {
    try {
      print("Re-initializing speech recognition...");
      _speechEnabled = await _speechToText.initialize();
      print("Speech recognition re-initialized: $_speechEnabled");
    } catch (e) {
      print("Error re-initializing speech recognition: $e");
      _speechEnabled = false;
    }
  }

  submitFinalAnswer(int qId, String answerText, BuildContext context, int mIndex) async {

    try {
      TipDialogHelper.loading("Submitting..");
      File? file;
      int answerType;

      // Determine answer type and file based on recording type
      switch (state.recordingType) {
        case RecordingType.none:
          answerType = 1; // Text-only answer
          file = null;
          break;
        case RecordingType.voice:
          answerType = 2; // Voice answer
          if (_currentRecordingPath != null) {
            file = File(_currentRecordingPath!);
          }
          break;
        case RecordingType.video:
          answerType = 3; // Video answer
          if (state.videoPath != null) {
            file = File(state.videoPath!);
          }
          break;
      }

      // Check if file exists for audio/video answers
      if (file != null && !file.existsSync()) {
        TipDialogHelper.dismiss();
        print("Error: Recorded file does not exist at path: ${file.path}");
        return ;
      }

      if (state.recordingType == RecordingType.video) {
        final result = await answerUseCase.getMuxUrl();
        result.fold(
          (l) {
            TipDialogHelper.dismiss();
            Utils.showInfoDialog(context: context, title: "Submission Failed", content: l.message ?? "Failed to submit answer. Please try again.");
          },
          (r) async {
            uploadVideoAnswer(r.uploadUrl ?? "", r.uploadId ?? "", file!.path, context, qId, mIndex);
          },
        );
        return;
      }

      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
      // For text-only answers, create a dummy file since the API signature requires it
      // but the repository implementation will handle text-only submissions differently
      final fileToSubmit = file ?? File('');
      final result = await answerUseCase.submitAnswer(qId: qId, userId: userId, answerType: answerType, answerText: answerText, file: fileToSubmit);
      TipDialogHelper.dismiss();
      result.fold(
        (l) {
          TipDialogHelper.dismiss();
          Utils.showInfoDialog(context: context, title: "Submission Failed", content: l.message ?? "Failed to submit answer. Please try again.");
        },
        (r) async {
          context.read<ListOfModuleCubit>().getExpandedCardData(questionId: qId, index: mIndex);
          context.read<ListOfModuleCubit>().isQuestionContinue(true);
          TipDialogHelper.success("Submitted");
          await Future.delayed(const Duration(milliseconds: 1200));
          TipDialogHelper.dismiss();
          retakeRecording();
          AppPreference().set(key: "SUBMITTED", value: "true");

          if(r.data?.showCongratulation==true){
          String? userName=  await AppPreference().get (key: AppPreference.KEY_USER_FIRST_NAME);
         bool? isSuccess =    await showCongratulationsDialog(context: context,userName: userName,content: r.data?.congratulationText,moduleName: r.data?.nextModuleTitle);
        if(isSuccess==true){
          Navigator.pop(context, true);
          AppPreference().set(key: "congratulation", value: "true");
        }else{
          AppPreference().set(key: "congratulation", value: "false");
        }
         emit(state.copyWith(showCongratsDialog: isSuccess));
          }else{
            Navigator.pop(context, true);
          }

        },
      );


    } catch (e) {

      TipDialogHelper.dismiss();
      print("Error submission: $e");
    }
  }

  void uploadVideoAnswer(String url, String uploadID, String filePath, BuildContext context, int qId, int mIndex) async {
    bool isUploading = true;
    // final result = await answerUseCase.uploadToMux(url, filePath);
    // uploadToMuxForeground(url, filePath);
    final result = await answerUseCase.uploadToMux(url, filePath);
    if (result) {
      final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);

      final body = {"question_id": qId, "user_id": userId, "upload_id": uploadID, "answer_type": 3};
      final result = await answerUseCase.uploadMuxVideoAssets(body);
      print("Upload result: $result");
      result.fold(
            (l) async {
          TipDialogHelper.dismiss();
          Utils.showInfoDialog(context: context, title: "Submission Failed", content: l.message ?? "Failed to submit answer. Please try again.");
          TipDialogHelper.success("Submission Failed");
          await Future.delayed(const Duration(milliseconds: 1200));
          TipDialogHelper.dismiss();
          retakeRecording();
          Navigator.pop(context, true);
        },
            (r) async {
              context.read<ListOfModuleCubit>().getExpandedCardData(questionId: qId, index: mIndex);
              TipDialogHelper.success("Submitted");
              await Future.delayed(const Duration(milliseconds: 1200));
              TipDialogHelper.dismiss();
              retakeRecording();
              AppPreference().set(key: "SUBMITTED", value: "true");
              if(r.data?.showCongratulation==true){
                String? userName=  await AppPreference().get (key: AppPreference.KEY_USER_FIRST_NAME);
                bool? isSuccess =    await showCongratulationsDialog(context: context,userName: userName,content: r.data?.congratulationText,moduleName: r.data?.nextModuleTitle);
                if(isSuccess==true){
                  Navigator.pop(context, true);
                  AppPreference().set(key: "congratulation", value: "true");
                }else{
                  AppPreference().set(key: "congratulation", value: "false");
                }
                emit(state.copyWith(showCongratsDialog: isSuccess));
              }else{
                Navigator.pop(context, true);
              }
        },
      );

    }
    else {
      TipDialogHelper.success("Submitted");
      await Future.delayed(const Duration(milliseconds: 1200));
      TipDialogHelper.dismiss();
      retakeRecording();
      Navigator.pop(context, true);
    }
    AppPreference().set(key: "SUBMITTED", value: "true");

  }



  Future<bool> uploadToMuxForeground(String url, String filePath) async {
    bool uploadResult = false;

    // await FlutterForegroundTask.startService(
    //   notificationTitle: 'Uploading video',
    //   notificationText: 'Upload in progress...',
    //   callback: (){
    //
    //   },
    // );

    // Run the upload
    final result = await answerUseCase.uploadToMux(url, filePath);
        if (result) {
    }

    // Stop foreground service after upload
    // await FlutterForegroundTask.stopService();

    return uploadResult;
  }


  void toggleFlash() {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final newFlashState = !state.isFlashOn;
        _cameraController!.setFlashMode(newFlashState ? FlashMode.torch : FlashMode.off);
        emit(state.copyWith(isFlashOn: newFlashState));
        print("Flash toggled to: $newFlashState");
      }
    } catch (e) {
      print("Error toggling flash: $e");
    }
  }

  void cyclePlaybackSpeed() {
    double newSpeed;
    switch (state.playbackSpeed) {
      case 0.5:
        newSpeed = 1.0;
        break;
      case 1.0:
        newSpeed = 1.5;
        break;
      case 1.5:
        newSpeed = 2.0;
        break;
      case 2.0:
        newSpeed = 0.5;
        break;
      default:
        newSpeed = 1.0;
    }

    emit(state.copyWith(playbackSpeed: newSpeed));
    print("Playback speed changed to: ${state.speedLabel}");
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras.first, ResolutionPreset.high, enableAudio: true);
    await _cameraController!.initialize();
  }

  // Flip camera function
  Future<void> flipCamera() async {
    print("🔄 Starting camera flip...");
    try {
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        print("❌ Camera controller not initialized");
        return;
      }

      // Ensure cameras are loaded
      if (_cameras.isEmpty) {
        print("📷 Loading available cameras...");
        _cameras = await availableCameras();
        print("📷 Found ${_cameras.length} cameras");
      }

      // Check if currently recording BEFORE any operations
      final wasRecording = _cameraController!.value.isRecordingVideo;
      final wasRecordingPaused = state.recordingState == RecordingState.paused;

      print("📹 Current state - wasRecording: $wasRecording, wasRecordingPaused: $wasRecordingPaused");

      final lensDirection = _cameraController!.description.lensDirection;
      print("🔄 Current camera: $lensDirection");

      // find the opposite camera
      CameraDescription newCamera;
      if (lensDirection == CameraLensDirection.front) {
        newCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
      } else {
        newCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
      }

      print("🔄 Switching to: ${newCamera.lensDirection}");

      // If recording, stop it and save the current segment
      if (wasRecording) {
        print("⏹️ Stopping current recording...");
        final videoFile = await _cameraController!.stopVideoRecording();
        _recordingTimer?.cancel();
        print("🎥 Stopped recording to flip camera: ${videoFile.path}");
      }

      // dispose old controller
      print("🗑️ Disposing old camera controller...");
      await _cameraController!.dispose();

      // create new controller
      print("🆕 Creating new camera controller...");
      _cameraController = CameraController(newCamera, ResolutionPreset.low, enableAudio: true);

      print("🔧 Initializing new camera controller...");
      await _cameraController!.initialize();

      // Restore flash state if it was on
      if (state.isFlashOn) {
        print("💡 Restoring flash state...");
        await _cameraController!.setFlashMode(FlashMode.torch);
      }

      // If was recording, start new recording with new camera
      if (wasRecording) {
        print("▶️ Starting new recording with flipped camera...");
        await _cameraController!.startVideoRecording();
        _startRecordingTimer();
        emit(state.copyWith(recordingState: RecordingState.recording));
        print("🎥 Started new recording with flipped camera");
      } else if (wasRecordingPaused) {
        print("▶️⏸️ Starting and pausing recording with new camera...");
        // If was paused, start recording and then pause immediately
        await _cameraController!.startVideoRecording();
        await _cameraController!.pauseVideoRecording();
        emit(state.copyWith(recordingState: RecordingState.paused));
        print("🎥 Started and paused recording with new camera");
      } else {
        print("🖼️ Just updating UI for preview mode...");
        // Just update UI for preview mode
        emit(state.copyWith());
      }

      print("✅ Camera successfully flipped to: ${newCamera.lensDirection}");
    } catch (e) {
      print("❌ Error flipping camera: $e");
      print("Stack trace: ${StackTrace.current}");
      // Try to restore recording state if something went wrong
      if (state.recordingState == RecordingState.recording) {
        emit(state.copyWith(recordingState: RecordingState.recording));
      }
    }
  }


  // New method: Flip camera and start completely new recording
  Future<void> flipCameraAndStartNew({isFront}) async {
    print("🔄 Flipping camera while recording continues...${state.isFrontCamera}");

    try {
      final controller = _cameraController;

      if (controller == null || !controller.value.isInitialized) {
        print("❌ Controller not initialized");
        return;
      }

      // 1️⃣ Pause recording temporarily (safe)
      XFile? pausedFile;
      if (controller.value.isRecordingVideo) {
        print("⏸ Pausing recording...");
        pausedFile = await controller.stopVideoRecording();
        _recordingTimer?.cancel();
      }


      // 2️⃣ Load cameras
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }

      final current = controller.description.lensDirection;

      // Find opposite camera
      CameraDescription newCamera;
      if (current == CameraLensDirection.back&&isFront==false) {

        newCamera = _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
        );
        emit(state.copyWith(isFrontCamera: true));
      } else {
        if(isFront==true&&state.isFrontCamera){
          newCamera = _cameras.firstWhere(
                (c) => c.lensDirection == CameraLensDirection.front,
          );
        }else{
        newCamera = _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
        );}
        emit(state.copyWith(isFrontCamera: false));
      }

      emit(state.copyWith(cameraInitialized: true));

      // 3️⃣ Dispose old controller
      print("🗑 Disposing old controller...");
      await controller.dispose();

      // 4️⃣ Initialize new controller
      print("🔧 Initializing new camera...");
      _cameraController = CameraController(newCamera, ResolutionPreset.high, enableAudio: true);
      await _cameraController!.initialize();
      await cameraController?.setFocusMode(FocusMode.auto);
      if(state.zoom==1.0){
        loadZoomLimits();
      }else{
        setZoom( state.zoom);
      }
       emit(state.copyWith(cameraInitialized: false));
      // Flash restore
      if (state.isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }

      // 5️⃣ Start new recording file (continue recording illusion)
      print("🎥 Starting new segment after flip...${state.isFrontCamera}");
       if(isFront){
         final directory = await getTemporaryDirectory();
         final videoPath = '${directory.path}/video_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';
       await _cameraController!.startVideoRecording();
      // Start timer again
          _startRecordingTimer();
       emit(state.copyWith(
         recordingState: RecordingState.recording,
         isVideoExist: true,
         videoPath: videoPath,
         isFrontCamera: true,
       ));
    }
       // if(state.recordingState== RecordingState.recording){
       //   emit(state.copyWith(isFrontCamera: false));
       // }else{
       //   emit(state.copyWith(isFrontCamera: true));
       // }

      print("🎥 Starting new segment after flip...2");
    } catch (e) {
      print("❌ Flip error: $e");
    }
  }

  // Future<String> removeMirrorInBackground(String inputPath) async {
  //   final dir = await getTemporaryDirectory();
  //   final outPath =
  //       '${dir.path}/fixed_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //
  //   final cmd =
  //       "-i \"$inputPath\" -vf hflip -c:v libx264 -preset veryfast -crf 23 -c:a copy \"$outPath\"";
  //
  //   await FFmpegKit.executeAsync(
  //     cmd,
  //         (session) async {
  //       final returnCode = await session.getReturnCode();
  //
  //       if (returnCode != null && returnCode.isValueSuccess()) {
  //         print("✔ Video saved in background: $outPath");
  //       } else {
  //         print("❌ FFmpeg failed in background");
  //       }
  //     },
  //         (log) {
  //       // Optional: logs
  //       print(log.getMessage());
  //     },
  //         (statistics) {
  //       // Optional: progress
  //       print(
  //         "⏳ Processing: ${statistics.getTime()} ms",
  //       );
  //     },
  //   );
  //
  //   // Immediately return output path (processing continues)
  //   return outPath;
  // }


  Future<String> removeMirrorInBackground(String inputPath) async {
    final dir = await getTemporaryDirectory();
    final outPath =
        '${dir.path}/fixed_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final cmd =
        "-i '$inputPath' -vf hflip -c:v libx264 -preset veryfast -crf 23 -c:a copy '$outPath'";

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();

    if (returnCode != null && returnCode.isValueSuccess()) {
      print("✔ FFmpeg mirror removed");
      return outPath;
    } else {
      print("❌ FFmpeg failed → returning original");
      return inputPath;
    }
  }

  // Future<void> flipCameraAndStartNew() async {
  //   print("🔄 Flipping camera and starting new recording...");
  //
  //   try {
  //     if (_cameraController == null || !_cameraController!.value.isInitialized) {
  //       print("❌ Camera controller not initialized");
  //       return;
  //     }
  //
  //     // Ensure cameras are loaded
  //     if (_cameras.isEmpty) {
  //       print("📷 Loading available cameras...");
  //       _cameras = await availableCameras();
  //       print("📷 Found ${_cameras.length} cameras");
  //     }
  //
  //     final lensDirection = _cameraController!.description.lensDirection;
  //     print("🔄 Current camera: $lensDirection");
  //
  //     // Find the opposite camera
  //     CameraDescription newCamera;
  //     if (lensDirection == CameraLensDirection.front) {
  //       newCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
  //     } else {
  //       newCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  //     }
  //
  //     print("🔄 Switching to: ${newCamera.lensDirection}");
  //
  //     // Stop any existing recording and reset everything
  //     if (state.recordingState == RecordingState.paused || state.recordingState == RecordingState.recording) {
  //       if (_cameraController!.value.isRecordingVideo) {
  //         await _cameraController!.stopVideoRecording();
  //       }
  //       _recordingTimer?.cancel();
  //       print("⏹️ Stopped previous recording");
  //     }
  //     emit(
  //       state.copyWith(cameraInitialized: false)
  //     );
  //     // Dispose old controller
  //     print("🗑️ Disposing old camera controller...");
  //     await _cameraController!.dispose();
  //
  //     // Create new controller with opposite camera
  //     print("🆕 Creating new camera controller...");
  //     _cameraController = CameraController(newCamera, ResolutionPreset.high, enableAudio: true);
  //
  //     print("🔧 Initializing new camera controller...");
  //     await _cameraController!.initialize();
  //     emit(
  //         state.copyWith(cameraInitialized: true)
  //     );
  //     // Restore flash state if it was on
  //     if (state.isFlashOn) {
  //       print("💡 Restoring flash state...");
  //       await _cameraController!.setFlashMode(FlashMode.torch);
  //     }
  //
  //     // Reset everything and start new recording
  //     print("🆕 Starting completely new recording...");
  //
  //     final directory = await getTemporaryDirectory();
  //     final videoPath = '${directory.path}/video_recording_${DateTime.now().millisecondsSinceEpoch}.mp4';
  //
  //     await _cameraController!.startVideoRecording();
  //     // _startRecordingTimer();
  //
  //     // Reset state completely - new recording from 0 seconds
  //     // emit(state.copyWith(recordingType: RecordingType.video, recordingState: RecordingState.recording, startTime: DateTime.now(), recordingDuration: Duration.zero, videoPath: videoPath));
  //     emit(
  //       state.copyWith(),
  //     );
  //     print("✅ Started new recording with ${newCamera.lensDirection} camera");
  //     print("⏰ Recording duration reset to 0 seconds");
  //   } catch (e) {
  //     print("❌ Error flipping camera and starting new: $e");
  //     print("Stack trace: ${StackTrace.current}");
  //   }
  // }

  // TTS Methods
  Future<void> startSpeaking(String text) async {
    try {
      await flutterTts.stop();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);

      // Set up completion listener
      flutterTts.setCompletionHandler(() {
        emit(state.copyWith(isSpeaking: false));
      });

      // Set up error listener
      flutterTts.setErrorHandler((msg) {
        emit(state.copyWith(isSpeaking: false));
      });

      // Set up cancel listener
      flutterTts.setCancelHandler(() {
        emit(state.copyWith(isSpeaking: false));
      });

      await flutterTts.speak(text);
      emit(state.copyWith(isSpeaking: true));
    } catch (e) {
      print("TTS Error: $e");
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await flutterTts.stop();
      emit(state.copyWith(isSpeaking: false));
    } catch (e) {
      print("TTS Stop Error: $e");
    }
  }

  void stopSpeakingOnInteraction() {
    if (state.isSpeaking) {
      stopSpeaking();
    }
  }

  // Word counting method
  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;

    // Split by whitespace and filter out empty strings
    final words = text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    return words.length;
  }

  // Update word count when text changes
  void updateWordCount(String text) {
    final wordCount = _countWords(text);
    print("wordCount:: $wordCount");
    emit(state.copyWith(wordCount: wordCount));
  }


  // video button active
  Future<void> videoButtonIdle() async {
    await initializeCamera();
    if(state.recordingState == RecordingState.idle){
      emit(state.copyWith(recordingType: RecordingType.video, recordingState: RecordingState.idle));

    }

  }
  void videoButtonActive() {
    if(state.recordingState == RecordingState.idle){
      emit(state.copyWith(recordingType: RecordingType.video, recordingState: RecordingState.paused));
      startVideoRecording();
    }

  }


  // page leave  dialog

  void confirmLeave() async{
    try{
      final videoFile = await _cameraController!.stopVideoRecording();
      if(File(videoFile.path).existsSync()){
        retakeRecording();
        emit(state.copyWith(leavePageDialogState: LeavePageDialogState.confirmed,isVideoExist: false,recordingType: RecordingType.none,recordingState: RecordingState.idle));
      }else{
        print("File deleted: Not Exist ${videoFile.path}");
      }
    }catch(e){
      print("Error deleting file: $e");
    }
    if(state.recordingType == RecordingType.video){
      try{
        final videoFile = await _cameraController!.stopVideoRecording();
        if(File(videoFile.path).existsSync()){
          File(videoFile.path).deleteSync();
          print("File deleted: ${videoFile.path}");
          emit(state.copyWith(
              leavePageDialogState: LeavePageDialogState.confirmed,isVideoExist: false,recordingType: RecordingType.none,recordingState: RecordingState.idle
          ));
        }
      }catch(e){
        print("Error deleting file: $e");

      }
    }else{
      final path = _currentRecordingPath;
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) {
          try {
            file.deleteSync();
            print("File deleted: $path");
          } catch (e) {
            print("Error deleting file: $e");
          }
        } else {
          print("No file found at path: $path");
        }
      }
      emit(state.copyWith(
          leavePageDialogState: LeavePageDialogState.confirmed,isAudioExist: false,recordingType: RecordingType.none,recordingState: RecordingState.idle
      ));
    }
  }


  void cancelLeave() {
    emit(state.copyWith(leavePageDialogState: LeavePageDialogState.cancelled));
  }

  void reset() {
    emit(state.copyWith(leavePageDialogState: LeavePageDialogState.initial));
  }



  //camera zoom
  Future<void> loadZoomLimits() async {
    final min = await cameraController?.getMinZoomLevel();
    final max = await cameraController?.getMaxZoomLevel();

    emit(state.copyWith(
      minZoom: min,
      maxZoom: max,
      zoom: min,
    ));
  }

  Future<void> setZoom(double value) async {
    if (!cameraController!.value.isInitialized) return;

    final zoom = value.clamp(state.minZoom, state.maxZoom);
    await cameraController?.setZoomLevel(zoom);
    await cameraController?.setFocusMode(FocusMode.auto);
    emit(state.copyWith(zoom: zoom));
  }

  // auto fucus
  Future<void> autoFocus({
    required Offset tapPosition,
    required Size previewSize,
  }) async {
    if (!cameraController!.value.isInitialized) return;

    if (cameraController?.description.lensDirection ==
        CameraLensDirection.front) {
      await cameraController?.setFocusMode(FocusMode.auto);
      return;
    }

    final dx = (tapPosition.dx / previewSize.width).clamp(0.0, 1.0);
    final dy = (tapPosition.dy / previewSize.height).clamp(0.0, 1.0);

    await cameraController?.setFocusMode(FocusMode.auto);
    await cameraController?.setFocusPoint(Offset(dx, dy));
    await cameraController?.setExposurePoint(Offset(dx, dy));
  }



}



