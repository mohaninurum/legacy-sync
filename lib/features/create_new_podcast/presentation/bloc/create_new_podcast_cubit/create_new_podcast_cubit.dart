import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/features/create_new_podcast/domain/usecases/create_new_podcast_usecase.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_state/create_new_podcast_state.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';

class CreateNewPodcastCubit extends Cubit<CreateNewPodcastState> {
  CreateNewPodcastCubit() : super(const CreateNewPodcastState());

  final CreateNewPodcastUseCase _useCase = CreateNewPodcastUseCase();
  final ImagePicker _picker = ImagePicker();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  File? coverImage;

  /// Pick image
  Future<void> pickCoverImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      coverImage = File(image.path);
      emit(state.copyWith()); // refresh UI
    }
  }

  Future<String> _generateShortRoomId() async {
    final prefs = AppPreference();

    final firstName =
    (await prefs.get(key: AppPreference.KEY_USER_FIRST_NAME))
        .trim()
        .toLowerCase();

    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();

    final randomPart = List.generate(
      6,
          (_) => chars[rand.nextInt(chars.length)],
    ).join();

    final namePart = firstName.isNotEmpty ? firstName : 'user';

    return '${namePart}_$randomPart';
  }


  Future<void> createPodcast() async {
    final userId = await AppPreference().getInt(
      key: AppPreference.KEY_USER_ID,
    );

    if (userId == null) {
      emit(
        state.copyWith(
          status: CreatePodcastStatus.failure,
          errorMessage: "User not found, try again",
        ),
      );
      return;
    }

    if (title.text.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CreatePodcastStatus.failure,
          errorMessage: "Title is required",
        ),
      );
      return;
    }

    if (coverImage == null) {
      emit(state.copyWith(
          status: CreatePodcastStatus.failure,
          errorMessage: "Please add cover image"));
      return;
    }

    emit(state.copyWith(status: CreatePodcastStatus.loading));

    final roomId = await _generateShortRoomId();

    final body = {
      "user_id": userId,
      "title": title.text.trim(),
      "description": description.text.trim(),
      "thumb_nail": "thumb.png",
      // "livekit_room_id": roomId,
    };

    final result = await _useCase.createNewPodcast(body: body,thumbnail: coverImage!,);

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: CreatePodcastStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: CreatePodcastStatus.success,
            podcastId: response.podcastId,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    title.dispose();
    description.dispose();
    return super.close();
  }
}
