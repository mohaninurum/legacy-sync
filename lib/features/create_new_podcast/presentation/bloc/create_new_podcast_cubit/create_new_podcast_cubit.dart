import 'dart:io';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/features/create_new_podcast/domain/usecases/create_new_podcast_usecase.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_state/create_new_podcast_state.dart';

class CreateNewPodcastCubit extends Cubit<CreateNewPodcastState> {
  CreateNewPodcastCubit({
    CreateNewPodcastUseCase? useCase,
    ImagePicker? picker,
  })  : _useCase = useCase ?? CreateNewPodcastUseCase(),
        _picker = picker ?? ImagePicker(),
        super(const CreateNewPodcastState());

  final CreateNewPodcastUseCase _useCase;
  final ImagePicker _picker;

  void setTitle(String value) {
    emit(state.copyWith(title: value, clearErrorMessage: true));
  }

  void setDescription(String value) {
    emit(state.copyWith(description: value, clearErrorMessage: true));
  }

  Future<void> pickCoverImage() async {
    if (state.isLoading) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    emit(state.copyWith(coverImagePath: image.path, clearErrorMessage: true));
  }


  bool _validateForm() {
    String? titleError;
    String? coverError;
    if (state.title.trim().isEmpty) titleError = "Title is required";

    final path = state.coverImagePath;
    if (path == null || path.isEmpty) {
      coverError = "Please add cover image";
    } else if (!File(path).existsSync()) {
      coverError = "Cover image not found, please pick again";
    }

    if (titleError != null || coverError != null) {
      emit(state.copyWith(
        status: CreatePodcastStatus.failure,
        titleError: titleError,
        coverError: coverError,
        generalError: null,
      ));
      return false;
    }

    return true;
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

  Future<void> createPodcast() async {
    if (state.isLoading) return;
    if (!_validateForm()) return;

    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final firstName = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    final lastName = await AppPreference().get(key: AppPreference.KEY_USER_LAST_NAME);
    final userName = "${firstName}_$lastName";

    print("FirstName New Podcast Cubit :: $firstName");
    print("LastName New Podcast Cubit :: $lastName");
    print("UserName New Podcast Cubit :: $userName");

    if (userId == null) {
      emit(state.copyWith(
        status: CreatePodcastStatus.failure,
        generalError: "User not found, try again",
      ));
      return;
    }

    emit(state.copyWith(status: CreatePodcastStatus.loading, clearErrorMessage: true));

    // Keep if you need it later, otherwise remove.
    final roomId = await _generateShortRoomId();

    print("ROOM ID CREATED SUCCESSFULLY :::: $roomId");

    emit(state.copyWith(roomId: roomId, userId: userId, userName: userName, clearErrorMessage: true));

    final body = <String, dynamic>{
      "user_id": userId,
      "title": state.title.trim(),
      "description": state.description.trim(),
      "livekit_room_id": roomId,
    };

    final thumbnailFile = File(state.coverImagePath!);

    final result = await _useCase.createNewPodcast(
      body: body,
      thumbnail: thumbnailFile,
    );

    result.fold(
          (failure) {
        emit(state.copyWith(
          status: CreatePodcastStatus.failure,
          generalError: failure.message,
        ));
      },
          (response) {
        emit(state.copyWith(
          status: CreatePodcastStatus.success,
          podcastId: response.podcastId,
        ));
      },
    );
  }

  /// Optional: call after showing snackbar to avoid repeated snackbars on rebuild
  void resetStatusToInitial() {
    if (state.status == CreatePodcastStatus.success || state.status == CreatePodcastStatus.failure) {
      emit(state.copyWith(status: CreatePodcastStatus.initial, clearErrorMessage: true));
    }
  }
}
