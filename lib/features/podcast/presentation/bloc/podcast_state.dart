

import '../../data/model/build_own_podcast_model.dart';

enum CreateRoomStatus { initial, loading, success, failure }

class PodcastState {
  final isLoading;
  List<BuildOwnPodcastModel> buildOwnPodcastList = [];

  //New
  final CreateRoomStatus createRoomStatus;
  final String? roomId;
  final int? userId;
  final String? userName;
  final String error;

   PodcastState({
    required this.isLoading,
    required this.buildOwnPodcastList,
     required this.createRoomStatus,
     required this.roomId,
     required this.userId,
     required this.userName,
     required this.error,
  });

  /// Initial state
  factory PodcastState.initial() {
    return  PodcastState(
      isLoading: false,
      buildOwnPodcastList: [],
      createRoomStatus: CreateRoomStatus.initial,
      roomId: '',
      userId: -1,
      userName: '',
      error: '',
    );
  }

  PodcastState copyWith({
    bool? isLoading,
    List<BuildOwnPodcastModel>? buildOwnPodcastList,
    CreateRoomStatus? createRoomStatus,
    String? roomId,
    int? userId,
    String? userName,
    String? error,
  }) {
    return PodcastState(
      isLoading: isLoading ?? this.isLoading,
      buildOwnPodcastList: buildOwnPodcastList ?? this.buildOwnPodcastList,
      createRoomStatus: createRoomStatus ?? this.createRoomStatus,
      roomId:roomId ?? this.roomId,
      userId:userId ?? this.userId,
      userName:userName ?? this.userName,
      error: error ?? this.error,
    );
  }
}
