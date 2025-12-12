import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';
import 'package:legacy_sync/features/card/data/model/updated_card_details.dart';
import 'package:legacy_sync/features/card/domain/repositories/card_repository.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class CardRepositoryImpl implements CardRepository {
  final NetworkApiService apiService;
  CardRepositoryImpl(this.apiService);

  @override
  ResultFuture<CardModel> getCard() async {
    // Simulate API call with dummy data
    final currentDate = DateTime.now();
    final formattedCurrentDate = DateFormat('dd/MM').format(currentDate);

    final dummyCard = CardModel(
      id: '1',
      title: "${AppService.userFirstName}'s Archive",
      subtitle: "Wisdom Streak",
      wisdomStreak: 0,
      memoriesCaptured: 00,
      legacyStartDate: formattedCurrentDate,
      selectedGradientIndex: 1,
    );

    return Right(dummyCard);
  }

  @override
  ResultFuture<CardModel> updateCardGradient(int gradientIndex) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final currentDate = DateTime.now();
    final formattedCurrentDate = DateFormat('dd/MM').format(currentDate);

    final updatedCard = CardModel(
      id: '1',
      title: "${AppService.userFirstName}'s Archive",
      subtitle: "Wisdom Streak",
      wisdomStreak: 0,
      memoriesCaptured: 00,
      legacyStartDate: formattedCurrentDate,
      selectedGradientIndex: gradientIndex,
    );

    return Right(updatedCard);
  }

  @override
  ResultFuture<List<GradientOption>> getGradientOptions() async {
    // Simulate API call

    final gradientOptions = [
      GradientOption(
        index: 0,
        colors: [
          const Color(0xFF7303C0),
          const Color(0xFFEC38BC),
          const Color(0xFFFDEFF9),
        ],
        name: "Pink to Darker Pink",
      ),
      GradientOption(
        index: 1,
        colors: [
          const Color(0xFF00D4AA),
          const Color(0xFFFF6B9D),
          const Color(0xFFFF9500),
        ],
        name: "Teal to Pink to Orange",
      ),
      GradientOption(
        index: 2,
        colors: [
          const Color(0xFFC02425),
          const Color(0xFFF0CB35),
          const Color(0xFFFF8C00),
        ],
        name: "Orange to Red-Orange",
      ),
      GradientOption(
        index: 3,
        colors: [
          const Color(0xFFC184FF),
          const Color(0xFFC9FFBF),
          const Color(0xFFFFAFBD),
        ],
        name: "Light Purple to Blue",
      ),
      GradientOption(
        index: 4,
        colors: [
          const Color(0xFF360033),
          const Color(0xFF0B8793),
          const Color(0xFF64B3F4),
        ],
        name: "Light Green to Green",
      ),
      GradientOption(
        index: 5,
        colors: [
          const Color(0xFF64B3F4),
          const Color(0xFFC2E59C),
          const Color(0xFFC5AF55),
        ],
        name: "Light Orange to Orange",
      ),
    ];

    return Right(gradientOptions);
  }

  @override
  ResultFuture<UpdatedCardDetails> getCardDetails({required int userID}) async{
    try {
      final res = await apiService.getGetApiResponse("${ApiURL.GET_SPLASH_DATA}$userID");
      return res.fold((error) => Left(error), (data) => Right(UpdatedCardDetails.fromJson(data)));
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
