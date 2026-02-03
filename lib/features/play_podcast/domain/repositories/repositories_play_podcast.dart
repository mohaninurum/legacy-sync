import 'package:dartz/dartz.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_favourite_response.dart';
import 'package:legacy_sync/features/play_podcast/data/model/mark_un_favourite_response.dart';

import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/network_api_service.dart';

abstract class RepositoriesPlayPodcast {
  ResultFuture<Map<String,dynamic>> saveListenedPodcastTime(Map<String, dynamic> body);
  ResultFuture<MarkFavouriteResponse> markFavouritePodcast(Map<String, dynamic> body);
  ResultFuture<MarkUnFavouriteResponse> markUnFavouritePodcast(Map<String, dynamic> body);
}
