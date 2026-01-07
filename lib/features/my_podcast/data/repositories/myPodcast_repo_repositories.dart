
import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';

import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';

import '../../../../config/network/api_host.dart';
import '../../../../config/network/app_exceptions.dart';
import '../../../../config/network/base_api_service.dart';
import '../../domain/repositories/my_podcast_repositories.dart';

class MyPodcastRepoRepositoriesRepoImpl extends MyPodcastRepositories {

  static final BaseApiServices _apiServices = NetworkApiService();


  @override
  ResultFuture<PodcastResponse> getMyPodcast(int userId) async {

    try {
     final res = await _apiServices.getGetApiResponse(
       "${ApiURL.my_podcast}$userId",
     );
     return res.fold(
           (error) => Left(error),
           (data) => Right(PodcastResponse.fromJson(data)),
     );
   } on AppException catch (e) {
     return Left(e);
   }
  }

}