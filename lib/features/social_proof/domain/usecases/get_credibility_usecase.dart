import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/social_proof/data/model/credibility_item.dart';
import 'package:legacy_sync/features/social_proof/domain/repositories/social_proof_repository.dart';

class GetCredibilityUseCase {
  final SocialProofRepository repository;
  GetCredibilityUseCase(this.repository);

  ResultFuture<List<CredibilityItem>> call() {
    return repository.getSocialProof();
  }
}
