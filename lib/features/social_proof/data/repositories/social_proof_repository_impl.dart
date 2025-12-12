import 'package:dartz/dartz.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/social_proof/data/model/credibility_item.dart';
import 'package:legacy_sync/features/social_proof/data/model/goal_item.dart';
import 'package:legacy_sync/features/social_proof/data/model/rating_item.dart';
import 'package:legacy_sync/features/social_proof/domain/repositories/social_proof_repository.dart';

class SocialProofRepositoryImpl implements SocialProofRepository {
  static final BaseApiServices _apiServices = NetworkApiService();

  @override
  ResultFuture<List<RatingItem>> getRatings() async {
    try {
      // Mock data for demonstration - will be replaced with API call
      final List<RatingItem> items = [
        const RatingItem(
          id: '1',
          userName: 'Eleanor R.',
          userHandle: '@EleanorMemories',
          avatarAsset: Images.eleanor,
          testimonial: '"This app has been a godsend for capturing my life\'s journey. It\'s so easy to use, and knowing my precious memories and stories are being preserved for my grandchildren gives me such peace of mind. Highly recommend for anyone wanting to leave a truly personal legacy!"',
          rating: 5,
          isVerified: true,
        ),
        const RatingItem(
          id: '2',
          userName: 'Richard T.',
          userHandle: '@RichardLegacy',
          avatarAsset: Images.richard,
          testimonial: '"I was looking for a way to pass on my life\'s lessons, and this app makes it incredibly simple. The AI assistant feels so natural, like I\'m really talking to someone who cares. My family will now have my wisdom for generations to come. Thank you!"',
          rating: 5,
          isVerified: true,
        ),
        const RatingItem(
          id: '3',
          userName: 'Susan P.',
          userHandle: '@SusanStories',
          avatarAsset: Images.susan,
          testimonial: '"I never thought I\'d find an app that could truly capture my voice and personality. It feels so unique and personal. It\'s not just about facts, but the real me. I\'m excited for my loved ones to experience this deep connection."',
          rating: 5,
          isVerified: true,
        ),
        const RatingItem(
          id: '4',
          userName: 'David L.',
          userHandle: '@DavidLegacy',
          avatarAsset: Images.david,
          testimonial: '"I initially felt overwhelmed by the idea of writing my life story, but this app broke it down beautifully. The questions are thought-provoking, and it\'s surprisingly easy to just start talking. It\'s making the daunting task of creating my legacy feel achievable and enjoyable."',
          rating: 5,
          isVerified: true,
        ),
      ];

      return Right(items);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture<List<CredibilityItem>> getSocialProof() async {
    try {
      final List<CredibilityItem> items = [
        const CredibilityItem(id: '1', authorName: 'Maya Angelou', quote: 'There is no greater agony than bearing an untold story inside you', avatarAsset: Images.person1, isVerified: true),
        const CredibilityItem(
          id: '2',
          authorName: 'Denzel Washington',
          quote:
              "At the end of the day, it's not about what you have or even what you've accomplished. It's about who you've lifted up. It's about who you've made better. It's about what you've given back",
          avatarAsset: Images.person2,
          isVerified: true,
        ),
        const CredibilityItem(
          id: '3',
          authorName: 'Oprah Winfrey',
          quote: 'What I know for sure is that speaking your truth is the most powerful tool we have',
          avatarAsset: Images.person3,
          isVerified: true,
        ),
        const CredibilityItem(
          id: '4',
          authorName: 'Dr. Brene Brown',
          quote: 'When we deny our stories, they define us. When we own our stories, we get to write a brave new ending.',
          avatarAsset: Images.person4,
          isVerified: true,
        ),
        const CredibilityItem(id: '5', authorName: 'Joan Didion', quote: 'We tell ourselves stories in order to live', avatarAsset: Images.person5, isVerified: true),
        const CredibilityItem(
          id: '6',
          authorName: 'Dr. Karl Pillemer',
          quote: "The simple act of sharing what you've learned can transform lives for generations.",
          avatarAsset: Images.person6,
          isVerified: true,
        ),
        const CredibilityItem(
          id: '7',
          authorName: 'Marcus Tullius Cicero',
          quote: 'To be ignorant of what occurred before you were born is to remain always a child.',
          avatarAsset: Images.person7,
          isVerified: true,
        ),
        const CredibilityItem(id: '8', authorName: 'Joseph Campbell', quote: 'Stories are not meant to entertain. They are meant to transform.', avatarAsset: Images.person8, isVerified: true),
        const CredibilityItem(
          id: '9',
          authorName: 'Fred Rogers',
          quote: "What's mentionable is manageable. When we talk about our feelings, they become less overwhelming, less upsetting, and less scary",
          avatarAsset: Images.person9,
          isVerified: true,
        ),
        const CredibilityItem(
          id: '10',
          authorName: 'Dr. Atul Gawande',
          quote: 'Ultimately, a good life is not just about avoiding death, it is about creating a meaningful narrative.',
          avatarAsset: Images.person10,
          isVerified: true,
        ),
        const CredibilityItem(
          id: '11',
          authorName: 'Tom Hanks',
          quote: 'The only way to make sure that people are listening to you is to tell them a good story.',
          avatarAsset: Images.person11,
          isVerified: true,
        ),
      ];

      return Right(items);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture<GoalResponse> getGoals() async {
    try {
      final res = await _apiServices.getGetApiResponse(ApiURL.goals);
      return res.fold((error) => Left(error), (data) => Right(GoalResponse.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<void> updateGoalSelection(int goalId, bool isSelected) {
    // TODO: implement updateGoalSelection
    throw UnimplementedError();
  }
}
