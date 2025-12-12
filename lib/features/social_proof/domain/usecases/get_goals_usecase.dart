import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/social_proof/data/model/goal_item.dart';
import 'package:legacy_sync/features/social_proof/domain/repositories/social_proof_repository.dart';

class GetGoalsUseCase {
  final SocialProofRepository repository;

  GetGoalsUseCase(this.repository);

  ResultFuture<GoalResponse> call() async {
    return await repository.getGoals();
  }
}
