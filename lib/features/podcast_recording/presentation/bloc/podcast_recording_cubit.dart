import 'dart:async';
import 'package:legacy_sync/features/podcast_recording/presentation/bloc/podcast_recording_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/podcast_topic/podcast_topics_model.dart';
import '../../data/user_list_model/user_list_model.dart';


class PodCastRecordingCubit extends Cubit<PodCastRecordingState> {
  Timer? _timer;
  List<UserListModel> users = [
    UserListModel.dummy(id: "1", name: "Dad",avatar: "assets/images/user_you.png"),
    UserListModel.dummy(id: "2", name: "Mom",avatar: "assets/images/user_you.png"),
    UserListModel.dummy(id: "3", name: "Sis",avatar: "assets/images/user_you.png"),
    UserListModel.dummy(id: "4", name: "Bro",avatar: "assets/images/user_you.png"),
  ];
  final topicsList = const [
    PodcastTopicsModel(
      id: "1",
      title: "Thinking Back to Your Earliest Clear Memory",
      description:
      "Thinking back to your earliest clear memory, what did you see, hear, or feel that still brings a vivid sense of that time to life for you today?",
  category: TopicCategory.relationship
    ),
    PodcastTopicsModel(
      id: "2",
      title: "A Turning Point in Your Life",
      description:
      "A decision or moment that changed your direction forever.",
        category: TopicCategory.family
    ),
    PodcastTopicsModel(
      id: "3",
      title: "A Lesson Learned the Hard Way",
      description:
      "Something experience taught you that books never could.",
        category: TopicCategory.family
    ),
  ];

  PodCastRecordingCubit() : super(PodCastRecordingState.initial());




  void loadTopics() {
    emit(state.copyWith(
      allTopics: topicsList,
      filteredTopics: topicsList,
      currentTopicIndex: 0,
    ));
  }

  /// 🔹 FILTER BY CATEGORY
  void filterByCategory(TopicCategory category) {
    final filtered = state.allTopics
        .where((t) => t.category == category)
        .toList();

    emit(state.copyWith(
      filteredTopics: filtered,
      selectedCategory: category,
      shuffle: false,
      currentTopicIndex: 0,
    ));
  }

  /// 🔹 SHUFFLE
  void shuffleTopics() {
    final shuffled = List<PodcastTopicsModel>.from(state.filteredTopics)
      ..shuffle();

    emit(state.copyWith(
      filteredTopics: shuffled,
      shuffle: true,
      currentTopicIndex: 0,
    ));
  }

  /// 🔹 NEXT
  void nextTopic() {
    if (state.currentTopicIndex <
        state.filteredTopics.length - 1) {
      emit(state.copyWith(
        currentTopicIndex: state.currentTopicIndex + 1,
      ));
    }
  }

  /// 🔹 PREVIOUS
  void previousTopic() {
    if (state.currentTopicIndex > 0) {
      emit(state.copyWith(
        currentTopicIndex: state.currentTopicIndex - 1,
      ));
    }
  }

  void addSelfParticipant() {
    emit(
      state.copyWith(
        participants: [UserListModel.dummy(id: "1", name: "Me",  avatar: "assets/images/user_you.png")],
      ),
    );
  }

  void startRecording() {
    // emit(state.copyWith(status: PodCastRecordingStatus.recording));
    // _startTimer();
  }

  void pauseRecording() {
    _timer?.cancel();
    emit(state.copyWith(status: PodCastRecordingStatus.paused));
  }

  void resumeRecording() {
    emit(state.copyWith(status: PodCastRecordingStatus.recording));
    _startTimer();
  }

  void stopRecording() {
    _timer?.cancel();
    emit(state.copyWith(status: PodCastRecordingStatus.completed));
  }

  void resetRecording() {
    _timer?.cancel();
    emit(PodCastRecordingState.initial());
  }

  void addParticipant(UserListModel user) {
    emit(
      state.copyWith(
        participants: [...state.participants, user],
      ),
    );
  }
  void getInviteUse() {
    emit(
      state.copyWith(
        inviteUserList: users,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(
          duration: state.duration + const Duration(seconds: 1),
        ),
      );
    });
  }




}
