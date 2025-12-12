import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/social_proof/data/model/credibility_item.dart';
import 'package:legacy_sync/features/social_proof/data/model/goal_item.dart';
import 'package:legacy_sync/features/social_proof/data/model/rating_item.dart';

abstract class SocialProofRepository {
  ResultFuture<List<RatingItem>> getRatings();
  ResultFuture<List<CredibilityItem>> getSocialProof();
  ResultFuture<GoalResponse> getGoals();
  Future<void> updateGoalSelection(int goalId, bool isSelected);
}
