 import '../../../my_podcast/data/podcast_model.dart';

enum MarkFavStatus {initial, loading, success, failure}
enum MarkUnFavStatus {initial, loading, success, failure}

class  PlayPodcastState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBookmark;
  final bool isScroll;
  final bool isOverlayManager;
  final double speed;
  final PodcastModel? podcast;
  final MarkFavStatus? markFavStatus;
  final String? markFavMessage;
  final MarkUnFavStatus? markUnFavStatus;
  final String? markUnFavMessage;


  const PlayPodcastState({
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isBookmark,
    required this.isScroll,
    required this.isOverlayManager,
    required this.speed,
    required this.podcast,
    required this.markFavStatus,
    required this.markFavMessage,
    required this.markUnFavStatus,
    required this.markUnFavMessage,
  });

  factory PlayPodcastState.initial() {
    return const PlayPodcastState(
      position: Duration(seconds: 0),
      duration: Duration(seconds: 0),
      isPlaying: false,
      isBookmark: false,
      isScroll: false,
      isOverlayManager: false,
      speed: 1.0,
      podcast: null,
      markFavStatus: MarkFavStatus.initial,
      markFavMessage: null,
      markUnFavStatus: MarkUnFavStatus.initial,
      markUnFavMessage: null,
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
    MarkFavStatus? markFavStatus,
    String? markFavMessage,
    MarkUnFavStatus? markUnFavStatus,
    String? markUnFavMessage,
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
      markFavStatus:markFavStatus ?? this.markFavStatus,
      markFavMessage:markFavMessage ?? this.markFavMessage,
      markUnFavStatus:markUnFavStatus ?? this.markUnFavStatus,
      markUnFavMessage:markUnFavMessage ?? this.markUnFavMessage,
    );
  }
}