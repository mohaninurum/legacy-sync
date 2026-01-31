import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/publish_response.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/save_as_draft.dart';

abstract class AudioPreviewEditRepositories {
  ResultFuture<SaveAsDraft> saveAsDraftMultipart({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,
  });

  ResultFuture<PublishResponse> publishPodcast({required int podcastId});
}