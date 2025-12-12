import 'package:legacy_sync/config/network/api_host.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/db/shared_preferences.dart';

class AppService  {
  static String userName = "";
  static String userFirstName = "";
  static String cachePath = "";

  static void initializeUserData() async{
    final f = await AppPreference().get(key: AppPreference.KEY_USER_FIRST_NAME);
    final l = await AppPreference().get(key: AppPreference.KEY_USER_LAST_NAME);
    final token = await AppPreference().get(key: AppPreference.KEY_USER_TOKEN);
    ApiURL.authToken = token;
    userFirstName = f;

    print("User First Name: $f");
    if(l.isEmpty){
      userName = f;
    }else{
      userName = "$f' $l";
    }

  }

}