import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/publish_response.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/save_as_draft.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/repositories/audio_preview_edit_repo_impl.dart';
import 'package:legacy_sync/features/audio_preview_edit/domain/repositories/audio_preview_edit_repositories.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

class AudioPreviewEditUseCase {
  final AudioPreviewEditRepositories repository = AudioPreviewEditRepoImpl();

  ResultFuture<SaveAsDraft> saveAsDraftMultipart({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,
  }) {
    return repository.saveAsDraftMultipart(
      fields: fields,
      thumbnailBytes: thumbnailBytes,
      thumbnailFileName: thumbnailFileName,
      thumbnailKey: thumbnailKey,
    );
  }

  ResultFuture<PublishResponse> publishPodcast({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,}) {
    return repository.publishPodcast(fields: fields,
      thumbnailBytes: thumbnailBytes,
      thumbnailFileName: thumbnailFileName,
      thumbnailKey: thumbnailKey,);
  }

  ResultFuture<MarkFavouriteResponse> markFavouritePodcast(Map<String, dynamic> body) async {
    return await repository.markFavouritePodcast(body);
  }

  ResultFuture<MarkUnFavouriteResponse> markUnFavouritePodcast(Map<String, dynamic> body) async {
    return await repository.markUnFavouritePodcast(body);
  }
}
