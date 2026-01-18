import 'dart:io';

import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/create_new_podcast/data/model/create_new_podcast_model.dart';

abstract class CreateNewPodcastRepositories {
  ResultFuture<CreateNewPodcastModel> createNewPodcast({required Map<String,dynamic> body,required File thumbnail,});
}