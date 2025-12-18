import 'dart:ui';

import 'package:legacy_sync/features/answer/data/model/answer.dart';

enum RecordingType { none, voice, video }

enum RecordingState { idle, recording, paused, completed, playing }
enum LeavePageDialogState {
  initial,
  confirmed,
  cancelled,
}
class AnswerState  {
  final bool isLoading;
  final bool isSpeaking;
  final List<AnswerData> answers;
  final String? errorMessage;
  final int currentQuestionId;
  final bool hasSelectedAnswers;
 final LeavePageDialogState leavePageDialogState;
  // Recording states
  final RecordingType recordingType;
  final RecordingState recordingState;
  final String transcribedText;
  final String audioFilePath;
  final String videoFilePath;
  final Duration recordingDuration;
  final bool isRecordingPaused;
  final bool isAudioExist;
  final bool isVideoExist;
  final bool? showCongratsDialog;


  // UI states
  final bool showContinueButton;
  final bool showRetakeButton;

  // Audio waveform samples (normalized 0..1)
  final List<double> waveform;

  // New properties for audio_waveforms
  final bool cameraInitialized;
  final bool permissionsGranted;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? videoPath;
  final bool isAudioPlaying;
  final bool isVideoPlaying;
  final bool isFlashOn;
  final double playbackSpeed;
  final int wordCount;
  final bool hasStartedRecording;
  final bool isFrontCamera;
  final bool isVideoProcess;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final Offset? focusPoint;

  const AnswerState({
    required this.isLoading,
    required this.isSpeaking,
    required this.answers,
    required this.isAudioExist,
    required this.isVideoExist,
    this.errorMessage,
    required this.currentQuestionId,
    required this.hasSelectedAnswers,
    required this.recordingType,
    required this.recordingState,
    required this.leavePageDialogState,
    required this.transcribedText,
    required this.audioFilePath,
    required this.videoFilePath,
    required this.recordingDuration,
    required this.isRecordingPaused,
    required this.showContinueButton,
    required this.showRetakeButton,
    required this.waveform,
    required this.cameraInitialized,
    required this.permissionsGranted,
    this.startTime,
    this.endTime,
    this.videoPath,
    required this.isAudioPlaying,
    required this.isVideoPlaying,
    required this.isFlashOn,
    required this.playbackSpeed,
    required this.wordCount,
    required this.hasStartedRecording,
    required this.isFrontCamera,
    required this.isVideoProcess,
    required this.showCongratsDialog,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    this.focusPoint,

  });

  factory AnswerState.initial() => const AnswerState(
    isLoading: false,
    isSpeaking: false,
    isAudioExist: false,
    isVideoExist: false,
    answers: [],
    currentQuestionId: 1,
    hasSelectedAnswers: false,
    recordingType: RecordingType.none,
    recordingState: RecordingState.idle,
    leavePageDialogState: LeavePageDialogState.initial,
    transcribedText: '',
    audioFilePath: '',
    videoFilePath: '',
    recordingDuration: Duration.zero,
    isRecordingPaused: false,
    showContinueButton: false,
    showRetakeButton: false,
    waveform: [],
    cameraInitialized: false,
    permissionsGranted: false,
    isAudioPlaying: false,
    isVideoPlaying: false,
    isFlashOn: false,
    playbackSpeed: 1.0,
    wordCount: 0,
    hasStartedRecording: false,
    isFrontCamera: false,
    isVideoProcess: false,
   showCongratsDialog:null,
    zoom: 1.0,
    minZoom: 1.0,
    maxZoom: 1.0,

  );

  AnswerState copyWith({
    bool? isLoading,
    bool? isSpeaking,
    bool? isAudioExist,
    bool? isVideoExist,
    List<AnswerData>? answers,
    String? errorMessage,
    int? currentQuestionId,
    bool? hasSelectedAnswers,
    RecordingType? recordingType,
    RecordingState? recordingState,
    LeavePageDialogState?leavePageDialogState,
    String? transcribedText,
    String? audioFilePath,
    String? videoFilePath,
    Duration? recordingDuration,
    bool? isRecordingPaused,
    bool? showContinueButton,
    bool? showRetakeButton,
    List<double>? waveform,
    bool? cameraInitialized,
    bool? permissionsGranted,
    DateTime? startTime,
    DateTime? endTime,
    String? videoPath,
    bool? isAudioPlaying,
    bool? isVideoPlaying,
    bool? isFlashOn,
    double? playbackSpeed,
    int? wordCount,
    bool? hasStartedRecording,
    bool? isFrontCamera,
    bool? isVideoProcess,
     bool? showCongratsDialog,
     double? zoom,
    double? minZoom,
    double? maxZoom,
    Offset? focusPoint,
  }) {
    return AnswerState(
      isLoading: isLoading ?? this.isLoading,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isAudioExist: isAudioExist ?? this.isAudioExist,
      isVideoExist: isVideoExist ?? this.isVideoExist,
      answers: answers ?? this.answers,
      errorMessage: errorMessage ?? this.errorMessage,
      currentQuestionId: currentQuestionId ?? this.currentQuestionId,
      hasSelectedAnswers: hasSelectedAnswers ?? this.hasSelectedAnswers,
      recordingType: recordingType ?? this.recordingType,
      recordingState: recordingState ?? this.recordingState,
      leavePageDialogState: leavePageDialogState ?? this.leavePageDialogState,
      transcribedText: transcribedText ?? this.transcribedText,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      videoFilePath: videoFilePath ?? this.videoFilePath,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      isRecordingPaused: isRecordingPaused ?? this.isRecordingPaused,
      showContinueButton: showContinueButton ?? this.showContinueButton,
      showRetakeButton: showRetakeButton ?? this.showRetakeButton,
      waveform: waveform ?? this.waveform,
      cameraInitialized: cameraInitialized ?? this.cameraInitialized,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      videoPath: videoPath ?? this.videoPath,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      wordCount: wordCount ?? this.wordCount,
      hasStartedRecording: hasStartedRecording ?? this.hasStartedRecording,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isVideoProcess: isVideoProcess ?? this.isVideoProcess,
      showCongratsDialog: showCongratsDialog ?? this.showCongratsDialog,
      zoom: zoom ?? this.zoom,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      focusPoint: focusPoint,
    );
  }

  List<AnswerData> get selectedAnswers =>
      answers.where((answer) => answer.isSelected).toList();
  bool get canProceed =>
      selectedAnswers.isNotEmpty || transcribedText.isNotEmpty;

  // Check if minimum word count is met for text answers
  bool get hasMinimumWords => wordCount >= 15;

  // Check if submit button should be visible based on recording type and word count
  bool get shouldShowSubmitButton {
    switch (recordingType) {
      case RecordingType.none:
        return hasMinimumWords; // Text-only answers need 15 words
      case RecordingType.voice:
      case RecordingType.video:
        return isCompleted; // Audio/video answers don't require text (optional)
    }
  }

  // Recording state getters
  bool get isVoiceRecording =>
      recordingType == RecordingType.voice &&
      recordingState == RecordingState.recording;
  bool get isVideoRecording =>
      recordingType == RecordingType.video &&
      recordingState == RecordingState.recording;
  bool get isRecording => recordingState == RecordingState.recording;
  bool get isPaused => recordingState == RecordingState.paused;
  bool get isCompleted => recordingState == RecordingState.completed;
  bool get isPlaying => recordingState == RecordingState.playing;

  // Duration formatting
  String get formattedDuration {
    final minutes = recordingDuration.inMinutes;
    final seconds = recordingDuration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get speedLabel {
    switch (playbackSpeed) {
      case 0.5:
        return '0.5x';
      case 1.0:
        return '1x';
      case 1.5:
        return '1.5x';
      case 2.0:
        return '2x';
      default:
        return '1x';
    }
  }




}
