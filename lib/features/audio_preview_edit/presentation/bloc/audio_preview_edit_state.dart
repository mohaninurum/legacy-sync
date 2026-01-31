enum SaveAsDraftStatus { initial, loading, success, failure }
enum PublishStatus { initial, loading, success, failure }

class AudioPreviewEditState {
  final bool isPlaying;
  final bool isBookmark;
  final Duration position;
  final Duration duration;
  final double speed;
  final double trimStart;
  final double trimEnd;
  final String? coverImage;
  final bool isAudioEdit;
  final bool isAudioInitial;
  final String? trimAudioPath;
  final String? title;
  final String? description;
  final SaveAsDraftStatus saveAsDraftStatus;
  final bool isBuffering;
  final bool isWaveLoading;
  final double waveDownloadProgress;
  final String? errorMessage;
  final PublishStatus publishStatus;
  final String? publishMessage;




  AudioPreviewEditState({
    required this.isPlaying,
    required this.isBookmark,
    required this.position,
    required this.duration,
    required this.speed,
    required this.trimStart,
    required this.trimEnd,
    required this.coverImage,
    required this.isAudioEdit,
    required this.isAudioInitial,
    required this.trimAudioPath,
    required this.title,
    required this.description,
    this.saveAsDraftStatus = SaveAsDraftStatus.initial,
    this.isBuffering = false,
    this.isWaveLoading = false,
    this.waveDownloadProgress = 0.0,
    this.errorMessage,
    this.publishStatus = PublishStatus.initial,
    this.publishMessage,
  });

  factory AudioPreviewEditState.initial() => AudioPreviewEditState(
    isPlaying: false,
    isBookmark: false,
    position: Duration.zero,
    duration: Duration.zero,
    speed: 1.0,
    trimStart: 0,
    trimEnd: 0,
    coverImage: null,
    isAudioEdit:false,
    isAudioInitial:false,
    trimAudioPath:null,
    title:null,
    description:null,
    saveAsDraftStatus: SaveAsDraftStatus.initial,
    isBuffering: false,
    isWaveLoading: false,
    waveDownloadProgress: 0.0,
    errorMessage: null,
    publishStatus: PublishStatus.initial,
    publishMessage: null,
  );

  AudioPreviewEditState copyWith({
    bool? isPlaying,
    bool? isBookmark,
    Duration? position,
    Duration? duration,
    double? speed,
    double? trimStart,
    double? trimEnd,
    String? coverImage,
    bool? isAudioEdit,
    bool? isAudioInitial,
    String? trimAudioPath,
    String? title,
    String? description,
    SaveAsDraftStatus? saveAsDraftStatus,
    bool? isBuffering,
    bool? isWaveLoading,
    double? waveDownloadProgress,
    String? errorMessage,
    PublishStatus? publishStatus,
    String? publishMessage,

  }) {
    return AudioPreviewEditState(
      isPlaying: isPlaying ?? this.isPlaying,
      isBookmark: isBookmark ?? this.isBookmark,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      trimStart: trimStart ?? this.trimStart,
      trimEnd: trimEnd ?? this.trimEnd,
      coverImage: coverImage ?? this.coverImage,
      isAudioEdit: isAudioEdit ?? this.isAudioEdit,
      isAudioInitial: isAudioInitial ?? this.isAudioInitial,
      trimAudioPath: trimAudioPath ?? this.trimAudioPath,
      title: title ?? this.title,
      description: description ?? this.description,
      saveAsDraftStatus: saveAsDraftStatus ?? this.saveAsDraftStatus,
      isBuffering: isBuffering ?? this.isBuffering,
      isWaveLoading: isWaveLoading ?? this.isWaveLoading,
      waveDownloadProgress: waveDownloadProgress ?? this.waveDownloadProgress,
      errorMessage: errorMessage ?? this.errorMessage,
      publishStatus: publishStatus ?? this.publishStatus,
      publishMessage: publishMessage ?? this.publishMessage,
    );
  }
}
