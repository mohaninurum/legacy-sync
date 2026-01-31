import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/publish_response.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/save_as_draft.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/repositories/audio_preview_edit_repo_impl.dart';
import 'package:legacy_sync/features/audio_preview_edit/domain/repositories/audio_preview_edit_repositories.dart';

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

  ResultFuture<PublishResponse> publishPodcast({required int podcastId}) {
    return repository.publishPodcast(podcastId: podcastId);
  }
}
