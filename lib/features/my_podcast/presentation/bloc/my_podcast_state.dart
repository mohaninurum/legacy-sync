import '../../data/podcast_model.dart';
import '../../data/recent_user_list_model.dart';


enum CallType {
  incoming,
  outgoing,
  Missed
}

enum CreateRoomStatus { initial, loading, success, failure }

class MyPodcastState {
  final CreateRoomStatus createRoomStatus;
  final String selectedTab;
  final String error;
  final List<PodcastModel> podcasts;
  final List<PodcastModel> listPodcastsContinueListening;
  final List<RecentUserListModel> recentUserList;
  final bool isLoading;
  final PodcastModel? podcast;

  //New
  final String? roomId;
  final int? userId;
  final String? userName;

  const MyPodcastState({
    required this.createRoomStatus,
    required this.selectedTab,
    required this.error,
    required this.podcasts,
    required this.listPodcastsContinueListening,
    required this.recentUserList,
    required this.isLoading,
    required this.podcast,
    required this.roomId,
    required this.userId,
    required this.userName,
  });

  factory MyPodcastState.initial() {
    return const MyPodcastState(
      createRoomStatus: CreateRoomStatus.initial,
      selectedTab: 'Posted',
      error: '',
      podcasts: [],
      listPodcastsContinueListening: [],
      recentUserList: [],
      isLoading: false,
      podcast: null,
      roomId: '',
      userId: -1,
      userName: '',
    );
  }

  MyPodcastState copyWith({
    CreateRoomStatus? createRoomStatus,
    String? selectedTab,
    String? error,
    List<PodcastModel>? podcasts,
    List<PodcastModel>? listPodcastsContinueListening,
    List<RecentUserListModel>? recentUserList,
    bool? isLoading,
    PodcastModel? podcast,
    String? roomId,
    int? userId,
    String? userName,
  }) {
    return MyPodcastState(
      createRoomStatus: createRoomStatus ?? this.createRoomStatus,
      selectedTab: selectedTab ?? this.selectedTab,
      error: error ?? this.error,
      podcasts: podcasts ?? this.podcasts,
      listPodcastsContinueListening: listPodcastsContinueListening??this.listPodcastsContinueListening,
      recentUserList: recentUserList??this.recentUserList,
      isLoading: isLoading ?? this.isLoading,
      podcast:podcast ?? this.podcast,
      roomId:roomId ?? this.roomId,
      userId:userId ?? this.userId,
      userName:userName ?? this.userName,
    );
  }
}
