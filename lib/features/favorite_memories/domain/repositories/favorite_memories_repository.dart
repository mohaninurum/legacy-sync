import 'package:legacy_sync/config/network/network.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/add_fav_que_model.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/remove_fav_que_model.dart';

abstract class FavoriteMemoriesRepository {
  ResultFuture<AddFavQueModel> addFavQuestion(Map<String, dynamic> body);
  ResultFuture<RemoveFavQueModel> removeFavQuestion(Map<String, dynamic> body);
  ResultFuture<ListOfFavQueModelData> getListOfFavQuestion(int userID);
}
