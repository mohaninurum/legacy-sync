import 'package:equatable/equatable.dart';

enum CreatePodcastStatus { initial, loading, success, failure }

class CreateNewPodcastState extends Equatable {
  final CreatePodcastStatus status;
  final String? errorMessage;
  final int? podcastId;

  const CreateNewPodcastState({
    this.status = CreatePodcastStatus.initial,
    this.errorMessage,
    this.podcastId,
  });

  CreateNewPodcastState copyWith({
    CreatePodcastStatus? status,
    String? errorMessage,
    int? podcastId,
}) {
    return CreateNewPodcastState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      podcastId: podcastId ?? this.podcastId,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, podcastId];
}
