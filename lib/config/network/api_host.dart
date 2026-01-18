import 'package:path_provider/path_provider.dart';

class ApiURL {
  final String hostUrl;
  ApiURL._(this.hostUrl);
  factory ApiURL.devENV() {
    return ApiURL._('http://139.59.57.87:5000/api');
  }

  factory ApiURL.prodENV() {
    return ApiURL._('http://139.59.57.87:5000/api');
  }

  static const String baseURL = 'http://139.59.57.87:5000/api';
  static String authToken = '';
  static const String sign_up = '$baseURL/users/sign-up';
  static const String sign_IN = '$baseURL/users/sign-in';
  static const String SEND_OTP_ON_EMAIL = '$baseURL/users/reset-password-otp';
  static const String RESET_PASSWORD = '$baseURL/users/reset-password';
  static const String survey = '$baseURL/survey/survey-questions';
  static const String goals = '$baseURL/goals';
  static const String submitAnswers = '$baseURL/legacy-modules/answers/submit';
  static const String legacy_module = '$baseURL/legacy-modules/legacy-module-questions/';
  static const String get_profile = '$baseURL/users/profile/';
  static const String update_profile = '$baseURL/users/profile';
  static const String upload_profile_image = '$baseURL/users/profile-image';
  static const String module_answers = '$baseURL/legacy-modules/answer-list';
  static const String delete_answers = '$baseURL/legacy-modules/answer/delete/';
  static const String social_login = '$baseURL/users/social-login';
  static const String submit_survey = '$baseURL/survey/submit-survey';
  static const String EDIT_PROFILE_PICTURE = '$baseURL/users/edit-profile-picture';
  static const String GET_FRIEND_LIST = '$baseURL/friend-list/';
  static const String ADD_NEW_FRIEND = '$baseURL/friend-list';
  static const String GET_LEGACY_HOME_MODULE = '$baseURL/legacy-modules/module-list/';
  static const String GET_SPLASH_DATA = '$baseURL/users/splash-screen/';
  static const String ADD_FAV_QUESTION = '$baseURL/favorite-questions/add';
  static const String REMOVE_FAV_QUESTION = '$baseURL/favorite-questions/remove';
  static const String GET_FAV_QUESTIONS = '$baseURL/favorite-questions/';
  static const String EDIT_PROFILE = '$baseURL/users/edit-profile-detail';
  static const String module_list = '$baseURL/legacy-modules/module-list/';
  static const String my_podcast = '$baseURL/podcast/';
  static const String varify_email = '$baseURL/users/varify-email';
  static const String livekit_generate_channel = '$baseURL/livekit/generate-channel';
  static const String podcast_topic = '$baseURL/podcast-topic';
  static const String podcast_Save_Listened_PodcastTime = '$baseURL/podcast/save-listened-podcast-time';
  static const String podcast__Listened_list = '$baseURL/podcast/continue-listening-podcast-list/';
  static const String recent_podcast_friend_list = '$baseURL/podcast/recent-podcast-friend-list/';
  static const String favourite_podcast_list = '$baseURL/favourite-podcast/';
  static const String create_new_podcast = '$baseURL/podcast/create-podcast';


}
