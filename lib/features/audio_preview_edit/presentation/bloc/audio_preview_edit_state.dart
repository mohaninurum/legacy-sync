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
      description:null
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
    );
  }
}
