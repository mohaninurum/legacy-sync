import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/add_fav_que_model.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/remove_fav_que_model.dart';
import 'package:legacy_sync/features/favorite_memories/data/repositories/favorite_memories_repository_impl.dart';

class GetFavoriteMemoriesUsecase {
  final FavoriteMemoriesRepositoryImpl repository = FavoriteMemoriesRepositoryImpl();
  ResultFuture<AddFavQueModel> addFavQuestion({required Map<String,dynamic> body}) async {
    return await repository.addFavQuestion(body);
  }

  ResultFuture<RemoveFavQueModel> removeFavQuestion({required Map<String,dynamic> body}) async {
    return await repository.removeFavQuestion(body);
  }

  ResultFuture<ListOfFavQueModelData> getListOfFavQuestion({required int userID}) async {
    return await repository.getListOfFavQuestion(userID);
  }
}