import 'dart:async';
import 'package:legacy_sync/features/podcast_recording/presentation/bloc/podcast_recording_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/db/shared_preferences.dart';
import '../../../../core/utils/utils.dart';
import '../../data/podcast_topic/podcast_topics_model.dart';
import '../../data/user_list_model/user_list_model.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/usecase_podcast_recording/usecase_podcast_recording.dart';

class PodCastRecordingCubit extends Cubit<PodCastRecordingState> {
  UsecasePodcastRecording usecasePodcastRecording = UsecasePodcastRecording();

  Timer? _timer;
  List<UserListModel> users = const [
    UserListModel(id: "1", name: "Dad", avatar: "assets/images/user_you.png"),
    UserListModel(id: "2", name: "Mom", avatar: "assets/images/user_you.png"),
    UserListModel(id: "3", name: "Sis", avatar: "assets/images/user_you.png"),
    UserListModel(id: "4", name: "Bro", avatar: "assets/images/user_you.png"),
  ];
  List<PodcastTopicsModel> topicsList =  [
    PodcastTopicsModel(
      id: "1",
      title: "Thinking Back to Your Earliest Clear Memory",
      description:
          "Thinking back to your earliest clear memory, what did you see, hear, or feel that still brings a vivid sense of that time to life for you today?",
      category: TopicCategory.relationship,
    ),
    PodcastTopicsModel(
      id: "2",
      title: "A Turning Point in Your Life",
      description: "A decision or moment that changed your direction forever.",
      category: TopicCategory.family,
    ),
    PodcastTopicsModel(
      id: "3",
      title: "A Lesson Learned the Hard Way",
      description: "Something experience taught you that books never could.",
      category: TopicCategory.family,
    ),
  ];

  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription? _recorderSub;

  PodCastRecordingCubit() : super(PodCastRecordingState.initial());

  Future<void> fetchPodcastTopics() async {
    TopicCategory category = TopicCategory.relationship;

    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    emit(state.copyWith(isLoading: true));
    final mypodcast = await usecasePodcastRecording.getPodcastTopic(userId);

    mypodcast.fold(
      (error) {
        print("APP EXCEPTION:: ${error.message}");
        Utils.closeLoader();
        emit(state.copyWith(isLoading: false, error: error.message));
      },
      (result) {
        Utils.closeLoader();
        if (result.data != null) {
          print("DATA ON SUCCESS:: ${result.data}");
          topicsList.clear();
          result.data.forEach((element) {
            if (element.topicType == 1) {
              category = TopicCategory.relationship;
            } else {
              category = TopicCategory.family;
            }
            topicsList.add(
              PodcastTopicsModel(
                title: element.topic,
                description: element.topic,
                id: element.id.toString(),
                category: category,
              ),
            );
          });
          emit(state.copyWith(isLoading: false));
        } else {
          emit(
            state.copyWith(isLoading: false, error: "No profile data found"),
          );
        }
      },
    );
    loadTopics();
  }

  void loadTopics() {
    final familyTopics =
        topicsList.where((t) => t.category == TopicCategory.family).toList();

    emit(
      state.copyWith(
        allTopics: topicsList,
        filteredTopics: familyTopics,
        selectedCategory: TopicCategory.family,
        currentTopicIndex: 0,
      ),
    );
  }

  void initiazeRecording() {
    emit(
      state.copyWith(
        status: PodCastRecordingStatus.idle,
        callStatus: CallStatus.disconnected,
      ),
    );
  }

  /// 🔹 FILTER BY CATEGORY
  void filterByCategory(TopicCategory category) {
    final filtered =
        state.allTopics.where((t) => t.category == category).toList();

    emit(
      state.copyWith(
        filteredTopics: filtered,
        selectedCategory: category,
        shuffle: false,
        currentTopicIndex: 0,
      ),
    );
  }

  /// 🔹 SHUFFLE
  void shuffleTopics(TopicCategory category) {
    final shuffled = List<PodcastTopicsModel>.from(state.allTopics)..shuffle();

    emit(
      state.copyWith(
        filteredTopics: shuffled,
        selectedCategory: category,
        currentTopicIndex: 0,
      ),
    );
  }

  /// 🔹 NEXT
  void nextTopic() {
    if (state.currentTopicIndex < state.filteredTopics.length - 1) {
      emit(state.copyWith(currentTopicIndex: state.currentTopicIndex + 1));
    }
  }

  /// 🔹 PREVIOUS
  void previousTopic() {
    if (state.currentTopicIndex > 0) {
      emit(state.copyWith(currentTopicIndex: state.currentTopicIndex - 1));
    }
  }

  void addSelfParticipant(bool incomingCall) {
    if (incomingCall) {
      emit(
        state.copyWith(
          participants: [
            const UserListModel(
              id: "1",
              name: "Naila",
              avatar: "assets/images/user_you.png",
            ),
            const UserListModel(
              id: "1",
              name: "You",
              avatar: "assets/images/user_you.png",
            ),
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          participants: [
            const UserListModel(
              id: "1",
              name: "You",
              avatar: "assets/images/user_you.png",
            ),
          ],
        ),
      );
    }
  }

  Future<void> startRecording() async {
    emit(state.copyWith(status: PodCastRecordingStatus.recording));
    _startTimer();
    // await _recorder.startRecorder(
    //   toFile: 'recording.aac',
    // );
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
    try {
      _timer?.cancel();
      emit(state.copyWith(status: PodCastRecordingStatus.completed));
    } catch (e) {
      print(e);
    }
  }

  void resetRecording() {
    _timer?.cancel();
    emit(PodCastRecordingState.initial());
  }

  void addParticipant(UserListModel user) {
    emit(
      state.copyWith(
        callStatus: CallStatus.connected,
        participants: [...state.participants, user],
      ),
    );
  }

  void getInviteUse() {
    emit(state.copyWith(inviteUserList: users));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(duration: state.duration + const Duration(seconds: 1)),
      );
    });
  }

  void endCall() {
    if (state.participants.length == 1) {
      return;
    }
    // final List<UserListModel> updatedParticipants =
    // List<UserListModel>.from(state.participants);
    //
    // if (updatedParticipants.isNotEmpty) {
    //   print("remove...");
    //   print(updatedParticipants.length);
    //   print(updatedParticipants.length - 2);
    //   updatedParticipants.removeAt(updatedParticipants.length - 1);
    // }
    // print(updatedParticipants.length);
    stopRecording();
    emit(
      state.copyWith(
        status: PodCastRecordingStatus.completed,
        callStatus: CallStatus.disconnected,
        // participants: updatedParticipants,
      ),
    );
  }

  //
  Future<void> initRecorder() async {
    await Permission.microphone.request();
    //
    // await _recorder.openRecorder();
    //
    // _recorder.setSubscriptionDuration(
    //   const Duration(milliseconds: 100),
    // );
    //
    // _recorderSub = _recorder.onProgress!.listen((event) {
    //   if (event.decibels != null) {
    //       state.copyWith(
    //       dbLevel:  normalize(event.decibels!)
    //       );
    //   }
    // });
  }

  double normalize(double db) {
    return ((db + 60) / 60).clamp(0.0, 1.0);
  }

  void speakerONOff() {
    if (state.isSpeaker == true) {
      emit(state.copyWith(isSpeaker: false));
    } else {
      emit(state.copyWith(isSpeaker: true));
    }
  }

  void micONOff() {
    if (state.isMic == true) {
      emit(state.copyWith(isMic: false));
    } else {
      emit(state.copyWith(isMic: true));
    }
  }
}
