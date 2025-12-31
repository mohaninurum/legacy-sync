 class  PlayPodcastState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBookmark;
  final double speed;

  const PlayPodcastState({
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isBookmark,
    required this.speed,
  });

  factory PlayPodcastState.initial() {
    return const PlayPodcastState(
      position: Duration(seconds: 0),
      duration: Duration(seconds: 0),
      isPlaying: true,
      isBookmark: false,
      speed: 1.0,

    );
  }

  PlayPodcastState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBookmark,
    double? speed,

  }) {
    return PlayPodcastState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBookmark: isBookmark ?? this.isBookmark,
      speed:speed?? this.speed,

    );
  }

}