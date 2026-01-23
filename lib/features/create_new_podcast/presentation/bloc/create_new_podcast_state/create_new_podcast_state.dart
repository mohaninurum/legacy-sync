import 'package:equatable/equatable.dart';

enum CreatePodcastStatus { initial, loading, success, failure }

class CreateNewPodcastState extends Equatable {
  final CreatePodcastStatus status;
  final String title;
  final String description;
  final String? coverImagePath;
  final String? titleError;
  final String? coverError;
  final String? generalError;
  final int? podcastId;
  final String? roomId;
  final int? userId;
  final String? userName;

  const CreateNewPodcastState({
    this.status = CreatePodcastStatus.initial,
    this.title = '',
    this.description = '',
    this.coverImagePath,
    this.titleError = '',
    this.coverError = '',
    this.generalError = '',
    this.podcastId,
    this.roomId = '',
    this.userId = -1,
    this.userName = '',
  });

  bool get isLoading => status == CreatePodcastStatus.loading;

  /// Basic form validity (tweak rules if you want)
  bool get isFormValid => title.trim().isNotEmpty && (coverImagePath?.isNotEmpty ?? false);

  CreateNewPodcastState copyWith({
    CreatePodcastStatus? status,
    String? title,
    String? description,
    String? coverImagePath,
    String? titleError,
    String? coverError,
    String? generalError,
    int? podcastId,
    String? roomId,
    int? userId,
    String? userName,
    bool clearErrorMessage = false,
  }) {
    return CreateNewPodcastState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverError: clearErrorMessage ? null : (coverError ?? this.coverError),
      titleError: clearErrorMessage ? null : (titleError ?? this.titleError),
      generalError: clearErrorMessage ? null : (generalError ?? this.generalError),
      podcastId: podcastId ?? this.podcastId,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [status, title, description, coverImagePath, titleError, coverError, generalError, podcastId, roomId, userId, userName];
}
