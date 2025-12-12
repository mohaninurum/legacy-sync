import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/config/network/network_api_service.dart';
import 'package:legacy_sync/features/card/data/model/card_model.dart';
import 'package:legacy_sync/features/card/data/repositories/card_repository_impl.dart';
import 'package:legacy_sync/features/card/domain/usecases/get_card_usecase.dart';
import 'package:legacy_sync/features/card/domain/usecases/get_gradient_options_usecase.dart';
import 'package:legacy_sync/features/card/domain/usecases/update_card_gradient_usecase.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_state/card_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class CardCubit extends Cubit<CardLoaded> {
  CardCubit() : super(CardLoaded.initial());
  final getCardUseCase = GetCardUseCase(CardRepositoryImpl(NetworkApiService()));

  void loadTextList() {
    List<String> texts = [
      "Hi ${AppService.userFirstName},\nWelcome to Legacy Sync",
      "Based on your choices, we've crafted your unique Legacy Path.",
      "This guide is tailored to help you capture what matters most",
      " Making sure your irreplaceable wisdom lives on.",
      "Now its time to invest in your self, and your future generations",
    ];
    emit(state.copyWith(texts: texts, curentIndex: 0, lastIndex: texts.length - 1));
  }

  void getCardDataFromServer() async {
    final userId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    final data = await getCardUseCase.getCardDetails(userId: userId);
    data.fold((l) {
    }, (r) {
      emit(state.copyWith(card: state.card.copyWith(memoriesCaptured: r.data?.memoriesCaptured,wisdomStreak:calculateTotalDays(r.data?.legacyStarted??"") ,legacyStartDate: formatToDayMonth(r.data?.legacyStarted??""),total_wisdom: r.data?.totalWisdom??0)));
    });
  }
  int calculateTotalDays(String dateString) {
    // Parse the given date string
    DateTime startDate = DateTime.parse(dateString);

    // Current date
    DateTime now = DateTime.now();

    // Difference in days
    return now.difference(startDate).inDays;
  }
  String formatToDayMonth(String dateString) {
    DateTime date = DateTime.parse(dateString);

    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');

    return "$day/$month";
  }


  String formatDateToDDMM(String dateTimeString) {
    try {
      DateTime date = DateTime.parse(dateTimeString);
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      return "$day/$month";
    } catch (e) {
      return "";
    }
  }

  Future<void> loadCard() async {
    String date = await AppPreference().get(key: AppPreference.LEGACY_STARTED);
    final capturedCount = await AppPreference().getInt(key: AppPreference.MEMORIES_CAPTURED);
    final gradientIndex = await AppPreference().getInt(key: AppPreference.KEY_GRADIENT_INDEX);

    if (date.isNotEmpty) {
      date = formatDateToDDMM(date);
    }

    try {
      final getGradientOptionsUseCase = GetGradientOptionsUseCase(CardRepositoryImpl(NetworkApiService()));

      final cardResult = await getCardUseCase();
      final gradientOptionsResult = await getGradientOptionsUseCase();

      cardResult.fold((failure) {}, (card) {
        gradientOptionsResult.fold((failure) {}, (gradientOptions) {
          if (date.isNotEmpty) {
            card = card.copyWith(legacyStartDate: date, memoriesCaptured: capturedCount);
          }
          emit(state.copyWith(card: card, gradientOptions: gradientOptions, showCard: true));
          final updatedCard = state.card.copyWith(selectedGradientIndex: gradientIndex);
          emit(state.copyWith(card: updatedCard));
        });
      });
    } catch (e) {
      print("Error ${e}");
    }
    getCardDataFromServer();
  }

  void showInitialCard() {
    emit(state.copyWith(showCard: true));
  }

  void showCustomization() {
    emit(state.copyWith(showCustomization: true));
  }

  void hideCustomization() {
    emit(state.copyWith(showCustomization: false));
  }

  Future<void> updateGradient(int gradientIndex) async {
    // Validate gradient index
    if (gradientIndex < 0 || gradientIndex >= state.gradientOptions.length) {
      return;
    }

    AppPreference().setInt(key: AppPreference.KEY_GRADIENT_INDEX, value: gradientIndex);
    // Update immediately for smooth UI transition
    final updatedCard = state.card.copyWith(selectedGradientIndex: gradientIndex);
    emit(state.copyWith(card: updatedCard));

    // // Update in background without affecting UI
    // try {
    //   final updateCardGradientUseCase = UpdateCardGradientUseCase(CardRepositoryImpl(NetworkApiService()));
    //   final result = await updateCardGradientUseCase(gradientIndex);
    //   result.fold(
    //     (failure) => null, // Silently handle failure
    //     (updatedCard) {
    //       // Update with server response if needed
    //       emit(state.copyWith(card: updatedCard));
    //     },
    //   );
    // } catch (e) {
    //   // Handle error silently
    //   print("Error updating gradient: $e");
    // }
  }

  void changeText(int curentIndex) {
    emit(state.copyWith(curentIndex: curentIndex + 1));
  }
}
