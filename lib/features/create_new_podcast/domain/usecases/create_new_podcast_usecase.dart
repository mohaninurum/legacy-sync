import 'dart:io';

import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/create_new_podcast/data/model/create_new_podcast_model.dart';
import 'package:legacy_sync/features/create_new_podcast/data/repositories/create_new_podcast_repo_impl.dart';
import 'package:legacy_sync/features/create_new_podcast/domain/repositories/create_new_podcast_repositories.dart';

class CreateNewPodcastUseCase {
  final CreateNewPodcastRepositories repository = CreateNewPodcastRepoImpl();

  ResultFuture<CreateNewPodcastModel> createNewPodcast({
    required Map<String, dynamic> body,
    required File thumbnail,
  }) async {
    return await repository.createNewPodcast(body: body,thumbnail: thumbnail);
  }
}