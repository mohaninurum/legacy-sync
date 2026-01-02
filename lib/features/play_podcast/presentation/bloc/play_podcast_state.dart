 import '../../../my_podcast/data/podcast_model.dart';

class  PlayPodcastState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBookmark;
  final bool isScroll;
  final bool isOverlayManager;
  final double speed;
  final PodcastModel? podcast;

  const PlayPodcastState({
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isBookmark,
    required this.isScroll,
    required this.isOverlayManager,
    required this.speed,
    required this.podcast,


  });

  factory PlayPodcastState.initial() {
    return const PlayPodcastState(
      position: Duration(seconds: 0),
      duration: Duration(seconds: 0),
      isPlaying: true,
      isBookmark: false,
      isScroll: false,
      isOverlayManager: false,
      speed: 1.0,
      podcast: null,

    );
  }

  PlayPodcastState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBookmark,
    bool? isScroll,
    bool? isOverlayManager,
    double? speed,
    PodcastModel? podcast,

  }) {
    return PlayPodcastState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBookmark: isBookmark ?? this.isBookmark,
      isScroll: isScroll ?? this.isScroll,
      isOverlayManager: isOverlayManager ?? this.isOverlayManager,
      speed:speed?? this.speed,
      podcast:podcast ?? this.podcast,
    );
  }

}