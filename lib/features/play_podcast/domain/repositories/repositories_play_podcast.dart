import 'package:dartz/dartz.dart';

import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/network_api_service.dart';

abstract class RepositoriesPlayPodcast {
  ResultFuture<Map<String,dynamic>> saveListenedPodcastTime(Map<String, dynamic> body);


}
