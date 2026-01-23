
import 'dart:math';

import 'package:legacy_sync/features/podcast/presentation/bloc/podcast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/db/shared_preferences.dart';
import '../../../../core/images/images.dart';
import '../../data/model/build_own_podcast_model.dart';
import '../../domain/podcast_usecase/podcast_usecase.dart';


class PodcastCubit extends Cubit<PodcastState> {
  PodcastCubit() : super(PodcastState.initial());
  PodcastUsecase podcastUsecase = PodcastUsecase();
  List<BuildOwnPodcastModel> buildOwnPodcastList = [
    BuildOwnPodcastModel(title: "Record Your Thoughts", subtitle: "Start recording solo or invite someone using a collaboration code.", image: Images.icon_1podcast),
    BuildOwnPodcastModel(title: "Use Question Cards", subtitle: "Pick a topic, we’ll give you conversation starters.", image: Images.icon_2podcast),
    BuildOwnPodcastModel(title: "Edit Your Podcast", subtitle: "Trim parts, adjust sound, and make it feel just right.", image: Images.icon_3podcast),
    BuildOwnPodcastModel(title: "Post or Save for Later",  subtitle: "Publish it for your collaborators or keep it as a draft.", image: Images.icon_4podcast),
  ];



  @override
  Future<void> close() async {

    return super.close();
  }

  void fetchBuildOnwPodcast() async {

    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(buildOwnPodcastList: buildOwnPodcastList));
    emit(state.copyWith(isLoading: false));


  }
  void startMakingPodcast() async {
    AppPreference().setBool(key: AppPreference.start_Making_Podcast, value:  true);
  }


  String _sanitize(String input) {
    final s = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return s.isEmpty ? 'user' : s;
  }

  Future<String> _generateShortRoomId() async {
    final prefs = AppPreference();
    final raw = await prefs.get(key: AppPreference.KEY_USER_FIRST_NAME);
    final namePart = _sanitize((raw ?? '').trim());

    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    final randomPart = List.generate(8, (_) => chars[rand.nextInt(chars.length)]).join();

    return '${namePart}_$randomPart';
  }

  Future<void> createRoomAndId() async {
    emit(state.copyWith(createRoomStatus: CreateRoomStatus.loading, error: ''));
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final firstName = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    final lastName = await AppPreference().get(key: AppPreference.KEY_USER_LAST_NAME);
    final userName = "${firstName}_$lastName";

    print("FirstName New Podcast Cubit :: $firstName");
    print("LastName New Podcast Cubit :: $lastName");
    print("UserName New Podcast Cubit :: $userName");

    if (userId == null) {
      emit(state.copyWith(
        createRoomStatus: CreateRoomStatus.failure,
        error: "Login session expired, try to login again!",
      ));
      return;
    }

    // Keep if you need it later, otherwise remove.
    final roomId = await _generateShortRoomId();

    print("ROOM ID CREATED SUCCESSFULLY :::: $roomId");

    emit(state.copyWith(createRoomStatus: CreateRoomStatus.success,roomId: roomId, userId: userId, userName: userName, error: ''));
  }
}