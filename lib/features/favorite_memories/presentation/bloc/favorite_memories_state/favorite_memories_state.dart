// import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model.dart';
// class FavoriteMemoriesState {
//   final bool isLoading;
//   final List<Questions>Questions data;
//   final String? errorMessage;
//
//
//   const FavoriteMemoriesState({required this.isLoading, required this.data, required this.errorMessage});
//   factory FavoriteMemoriesState.initial() => FavoriteMemoriesState(isLoading: false,data: Questions.empty(),errorMessage: null);
//
//   FavoriteMemoriesState copyWith({bool? isLoading, Questions? data, String? errorMessage}){
//     return FavoriteMemoriesState(isLoading: isLoading ?? this.isLoading, data: data ?? this.data, errorMessage: errorMessage ?? this.errorMessage);
//   }
// }

import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';

class FavoriteMemoriesState {
  final String selectedTab;
  final bool isLoading;
  final String? errorMessage;
  final List<FavoriteModelData> favoriteQuestions;
  final List<PodcastModel> podcasts;


  FavoriteMemoriesState({
    required this.selectedTab,
    required this.isLoading,
    required this.favoriteQuestions,
    required this.podcasts,
    this.errorMessage,
  });

  factory FavoriteMemoriesState.initial() => FavoriteMemoriesState(
    selectedTab: "Memories",
    isLoading: false,
    favoriteQuestions: [],
    podcasts: [],
    errorMessage: null,
  );

  FavoriteMemoriesState copyWith({
    String? selectedTab,
    bool? isLoading,
    String? errorMessage,
    List<FavoriteModelData>? favoriteQuestions,
    List<PodcastModel>? podcasts,
  }) {
    return FavoriteMemoriesState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteQuestions: favoriteQuestions ?? this.favoriteQuestions,
      podcasts: podcasts ?? this.podcasts,
    );
  }
}
