// enum SaveAsDraftStatus { initial, loading, success, failure }
// enum PublishStatus { initial, loading, success, failure }
// enum MarkFavStatus {initial, loading, success, failure}
// enum MarkUnFavStatus {initial, loading, success, failure}
// enum DeleteStatus { initial, loading, success, failure }
//
// class AudioPreviewEditState {
//   final bool isPlaying;
//   final bool isBookmark;
//   final Duration position;
//   final Duration duration;
//   final double speed;
//   final double trimStart;
//   final double trimEnd;
//   final String? coverImage;
//   final bool isAudioEdit;
//   final bool isAudioInitial;
//   final String? trimAudioPath;
//   final String? title;
//   final String? description;
//   final SaveAsDraftStatus saveAsDraftStatus;
//   final String? draftMessage;
//   final bool isBuffering;
//   final bool isWaveLoading;
//   final double waveDownloadProgress;
//   final String? errorMessage;
//   final PublishStatus publishStatus;
//   final String? publishMessage;
//   final MarkFavStatus? markFavStatus;
//   final String? markFavMessage;
//   final MarkUnFavStatus? markUnFavStatus;
//   final String? markUnFavMessage;
//   final DeleteStatus deleteStatus;
//   final String? deleteMessage;
//
//
//
//
//   AudioPreviewEditState({
//     required this.isPlaying,
//     required this.isBookmark,
//     required this.position,
//     required this.duration,
//     required this.speed,
//     required this.trimStart,
//     required this.trimEnd,
//     required this.coverImage,
//     required this.isAudioEdit,
//     required this.isAudioInitial,
//     required this.trimAudioPath,
//     required this.title,
//     required this.description,
//     this.saveAsDraftStatus = SaveAsDraftStatus.initial,
//     this.draftMessage,
//     this.isBuffering = false,
//     this.isWaveLoading = false,
//     this.waveDownloadProgress = 0.0,
//     this.errorMessage,
//     this.publishStatus = PublishStatus.initial,
//     this.publishMessage,
//     required this.markFavStatus,
//     required this.markFavMessage,
//     required this.markUnFavStatus,
//     required this.markUnFavMessage,
//     this.deleteStatus = DeleteStatus.initial,
//     this.deleteMessage,
//   });
//
//   factory AudioPreviewEditState.initial() => AudioPreviewEditState(
//     isPlaying: false,
//     isBookmark: false,
//     position: Duration.zero,
//     duration: Duration.zero,
//     speed: 1.0,
//     trimStart: 0,
//     trimEnd: 0,
//     coverImage: null,
//     isAudioEdit:false,
//     isAudioInitial:false,
//     trimAudioPath:null,
//     title:null,
//     description:null,
//     saveAsDraftStatus: SaveAsDraftStatus.initial,
//     draftMessage: null,
//     isBuffering: false,
//     isWaveLoading: false,
//     waveDownloadProgress: 0.0,
//     errorMessage: null,
//     publishStatus: PublishStatus.initial,
//     publishMessage: null,
//     markFavStatus: MarkFavStatus.initial,
//     markFavMessage: null,
//     markUnFavStatus: MarkUnFavStatus.initial,
//     markUnFavMessage: null,
//     deleteStatus: DeleteStatus.initial,
//     deleteMessage: null,
//   );
//
//   AudioPreviewEditState copyWith({
//     bool? isPlaying,
//     bool? isBookmark,
//     Duration? position,
//     Duration? duration,
//     double? speed,
//     double? trimStart,
//     double? trimEnd,
//     String? coverImage,
//     bool? isAudioEdit,
//     bool? isAudioInitial,
//     String? trimAudioPath,
//     String? title,
//     String? description,
//     SaveAsDraftStatus? saveAsDraftStatus,
//     String? draftMessage,
//     bool? isBuffering,
//     bool? isWaveLoading,
//     double? waveDownloadProgress,
//     String? errorMessage,
//     PublishStatus? publishStatus,
//     String? publishMessage,
//     MarkFavStatus? markFavStatus,
//     String? markFavMessage,
//     MarkUnFavStatus? markUnFavStatus,
//     String? markUnFavMessage,
//     DeleteStatus? deleteStatus,
//     String? deleteMessage,
//
//   }) {
//     return AudioPreviewEditState(
//       isPlaying: isPlaying ?? this.isPlaying,
//       isBookmark: isBookmark ?? this.isBookmark,
//       position: position ?? this.position,
//       duration: duration ?? this.duration,
//       speed: speed ?? this.speed,
//       trimStart: trimStart ?? this.trimStart,
//       trimEnd: trimEnd ?? this.trimEnd,
//       coverImage: coverImage ?? this.coverImage,
//       isAudioEdit: isAudioEdit ?? this.isAudioEdit,
//       isAudioInitial: isAudioInitial ?? this.isAudioInitial,
//       trimAudioPath: trimAudioPath ?? this.trimAudioPath,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       saveAsDraftStatus: saveAsDraftStatus ?? this.saveAsDraftStatus,
//       draftMessage: draftMessage ?? this.draftMessage,
//       isBuffering: isBuffering ?? this.isBuffering,
//       isWaveLoading: isWaveLoading ?? this.isWaveLoading,
//       waveDownloadProgress: waveDownloadProgress ?? this.waveDownloadProgress,
//       errorMessage: errorMessage ?? this.errorMessage,
//       publishStatus: publishStatus ?? this.publishStatus,
//       publishMessage: publishMessage ?? this.publishMessage,
//       markFavStatus:markFavStatus ?? this.markFavStatus,
//       markFavMessage:markFavMessage ?? this.markFavMessage,
//       markUnFavStatus:markUnFavStatus ?? this.markUnFavStatus,
//       markUnFavMessage:markUnFavMessage ?? this.markUnFavMessage,
//       deleteStatus: deleteStatus ?? this.deleteStatus,
//       deleteMessage: deleteMessage ?? this.deleteMessage,
//     );
//   }
// }

enum SaveAsDraftStatus { initial, loading, success, failure }

enum PublishStatus { initial, loading, success, failure }

enum MarkFavStatus { initial, loading, success, failure }

enum MarkUnFavStatus { initial, loading, success, failure }

enum DeleteStatus { initial, loading, success, failure }

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
  final String? draftMessage;
  final bool isBuffering;
  final bool isWaveLoading;
  final double waveDownloadProgress;
  final String? errorMessage;
  final PublishStatus publishStatus;
  final String? publishMessage;
  final MarkFavStatus markFavStatus;
  final String? markFavMessage;
  final MarkUnFavStatus markUnFavStatus;
  final String? markUnFavMessage;
  final DeleteStatus deleteStatus;
  final String? deleteMessage;

  const AudioPreviewEditState({
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
    this.draftMessage,
    this.isBuffering = false,
    this.isWaveLoading = false,
    this.waveDownloadProgress = 0.0,
    this.errorMessage,
    this.publishStatus = PublishStatus.initial,
    this.publishMessage,
    this.markFavStatus = MarkFavStatus.initial,
    this.markFavMessage,
    this.markUnFavStatus = MarkUnFavStatus.initial,
    this.markUnFavMessage,
    this.deleteStatus = DeleteStatus.initial,
    this.deleteMessage,
  });

  factory AudioPreviewEditState.initial() => const AudioPreviewEditState(
    isPlaying: false,
    isBookmark: false,
    position: Duration.zero,
    duration: Duration.zero,
    speed: 1.0,
    trimStart: 0,
    trimEnd: 0,
    coverImage: null,
    isAudioEdit: false,
    isAudioInitial: false,
    trimAudioPath: null,
    title: null,
    description: null,
    saveAsDraftStatus: SaveAsDraftStatus.initial,
    draftMessage: null,
    isBuffering: false,
    isWaveLoading: false,
    waveDownloadProgress: 0.0,
    errorMessage: null,
    publishStatus: PublishStatus.initial,
    publishMessage: null,
    markFavStatus: MarkFavStatus.initial,
    markFavMessage: null,
    markUnFavStatus: MarkUnFavStatus.initial,
    markUnFavMessage: null,
    deleteStatus: DeleteStatus.initial,
    deleteMessage: null,
  );

  AudioPreviewEditState copyWith({
    bool? isPlaying,
    bool? isBookmark,
    Duration? position,
    Duration? duration,
    double? speed,
    double? trimStart,
    double? trimEnd,
    Object? coverImage = _unset,
    bool? isAudioEdit,
    bool? isAudioInitial,
    Object? trimAudioPath = _unset,
    Object? title = _unset,
    Object? description = _unset,
    SaveAsDraftStatus? saveAsDraftStatus,
    Object? draftMessage = _unset,
    bool? isBuffering,
    bool? isWaveLoading,
    double? waveDownloadProgress,
    Object? errorMessage = _unset,
    PublishStatus? publishStatus,
    Object? publishMessage = _unset,
    MarkFavStatus? markFavStatus,
    Object? markFavMessage = _unset,
    MarkUnFavStatus? markUnFavStatus,
    Object? markUnFavMessage = _unset,
    DeleteStatus? deleteStatus,
    Object? deleteMessage = _unset,
  }) {
    return AudioPreviewEditState(
      isPlaying: isPlaying ?? this.isPlaying,
      isBookmark: isBookmark ?? this.isBookmark,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      trimStart: trimStart ?? this.trimStart,
      trimEnd: trimEnd ?? this.trimEnd,
      coverImage: identical(coverImage, _unset) ? this.coverImage : coverImage as String?,
      isAudioEdit: isAudioEdit ?? this.isAudioEdit,
      isAudioInitial: isAudioInitial ?? this.isAudioInitial,
      trimAudioPath:
          identical(trimAudioPath, _unset)
              ? this.trimAudioPath
              : trimAudioPath as String?,
      title: identical(title, _unset) ? this.title : title as String?,
      description:
          identical(description, _unset) ? this.description : description as String?,
      saveAsDraftStatus: saveAsDraftStatus ?? this.saveAsDraftStatus,
      draftMessage:
          identical(draftMessage, _unset) ? this.draftMessage : draftMessage as String?,
      isBuffering: isBuffering ?? this.isBuffering,
      isWaveLoading: isWaveLoading ?? this.isWaveLoading,
      waveDownloadProgress: waveDownloadProgress ?? this.waveDownloadProgress,
      errorMessage:
          identical(errorMessage, _unset) ? this.errorMessage : errorMessage as String?,
      publishStatus: publishStatus ?? this.publishStatus,
      publishMessage:
          identical(publishMessage, _unset)
              ? this.publishMessage
              : publishMessage as String?,
      markFavStatus: markFavStatus ?? this.markFavStatus,
      markFavMessage:
          identical(markFavMessage, _unset)
              ? this.markFavMessage
              : markFavMessage as String?,
      markUnFavStatus: markUnFavStatus ?? this.markUnFavStatus,
      markUnFavMessage:
          identical(markUnFavMessage, _unset)
              ? this.markUnFavMessage
              : markUnFavMessage as String?,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deleteMessage:
          identical(deleteMessage, _unset)
              ? this.deleteMessage
              : deleteMessage as String?,
    );
  }
}

const Object _unset = Object();
