import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/social_proof/data/model/rating_item.dart';
import 'package:legacy_sync/features/social_proof/domain/repositories/social_proof_repository.dart';

class GetRatingsUseCase {
  final SocialProofRepository repository;

  GetRatingsUseCase(this.repository);

  ResultFuture<List<RatingItem>> call() async {
    return await repository.getRatings();
  }
}
