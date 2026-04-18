import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/publish_response.dart';
import 'package:legacy_sync/features/audio_preview_edit/data/model/save_as_draft.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

abstract class AudioPreviewEditRepositories {
  ResultFuture<SaveAsDraft> saveAsDraftMultipart({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,
  });

  ResultFuture<PublishResponse> publishPodcast({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,});

  ResultFuture<MarkFavouriteResponse> markFavouritePodcast(Map<String, dynamic> body);
  ResultFuture<MarkUnFavouriteResponse> markUnFavouritePodcast(Map<String, dynamic> body);

  ResultFuture<Map<String, dynamic>> deletePodcastDraft(Map<String, dynamic> body);

  ResultFuture<PublishResponse> editPublishedPodcast({
    required Map<String, String> fields,
    required List<int>? thumbnailBytes,
    required String thumbnailFileName,
    required String thumbnailKey,
  });
}