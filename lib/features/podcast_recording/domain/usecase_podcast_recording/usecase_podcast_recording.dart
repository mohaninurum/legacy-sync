

import '../../../../config/network/network_api_service.dart';
import '../../data/podcast_topic/podcast_topics_model.dart';
import '../../data/repositories/podcast_repo_impl.dart';

class UsecasePodcastRecording {
  final PodcastRecordingRepoImpl repository = PodcastRecordingRepoImpl();

  ResultFuture<PodcastTopicResponse> getPodcastTopic(int userId) async {
    return await repository.getPodcastTopic(userId);
  }


}
