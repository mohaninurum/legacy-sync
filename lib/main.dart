import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_video_player_plus/util/migration_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:legacy_sync/config/routes/routes.dart';
import 'package:legacy_sync/core/app_sizes/app_sizes.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/config/theme/app_theme.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_complete_cubit.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/login_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/reset_password_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/signup_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/verification_code_cubit.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_bloc/card_cubit.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_cubit/create_new_podcast_cubit.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/list_of_module/list_of_module.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
import 'package:legacy_sync/features/question/presentation/bloc/question_bloc/question_cubit.dart';
import 'package:legacy_sync/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/choose_your_goals_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/credibility_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/rating_cubit.dart';
import 'package:legacy_sync/features/post_paywall/presentation/bloc/post_paywall_cubit.dart';
import 'package:legacy_sync/features/answer/presentation/bloc/answer_bloc/answer_cubit.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';
import 'package:legacy_sync/services/notification_service/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'config/network/api_host.dart';
import 'features/audio_preview_edit/presentation/bloc/audio_preview_edit_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc/email_verification_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc/social_login_cubit.dart';
import 'features/friends_profile/presentation/bloc/profile_bloc/friends_profile_cubit.dart';
import 'features/legacy_wrapped/presentation/bloc/legacy_wrapped_bloc/legacy_wrapped_cubit.dart';
import 'features/my_podcast/presentation/bloc/my_podcast_cubit.dart';
import 'features/paywall/presentation/bloc/paywall_cubit.dart';
import 'features/play_podcast/presentation/bloc/play_podcast_cubit.dart';
import 'features/podcast/presentation/bloc/podcast_cubit.dart';
import 'features/podcast_recording/presentation/bloc/podcast_recording_cubit.dart';
import 'features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';
import 'features/home/presentation/bloc/home_bloc/home_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

Map<String, dynamic>? pendingCallArguments;

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // It's OK if already initialized
  }

  final data = message.data;

  final roomId = (data['room_id'] ?? '').toString();
  if (roomId.isEmpty) return;

  final callId = (data['callId']?.toString().isNotEmpty == true)
      ? message.data['callId'].toString()
      : DateTime.now().millisecondsSinceEpoch.toString();

  final params = CallKitParams(
    id: callId,
    nameCaller: (data['user_name'] ?? 'Incoming Call').toString(),
    handle: (data['room_id'] ?? 'call').toString(),
    type: int.tryParse((data['callType'] ?? '0').toString()) ?? 0,

    duration: 30000,
    extra: {
      'room_id': (data['room_id'] ?? '').toString(),
      'user_id': (data['user_id'] ?? '').toString(),
      'user_name': (data['user_name'] ?? '').toString(),
      'profile_image': (data['profile_image'] ?? '').toString(),
      'notification_status': (data['notification_status'] ?? '').toString(),
    },
    android: const AndroidParams(
      isCustomNotification: false,
      ringtonePath: 'system_ringtone_default',
    ),
    ios: const IOSParams(
      handleType: 'generic',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}


void _listenCallKitEvents() {
  FlutterCallkitIncoming.onEvent.listen((event) async {
    if (event == null) return;
    switch (event.event) {
      case Event.actionCallAccept:
        final body = event.body ?? {};
        final extra = (body['extra'] ?? {}) as Map;

        pendingCallArguments = {
          "incoming_call": true,
          "room_id": (extra['room_id'] ?? "").toString(),
          "user_id": (extra['user_id'] ?? "").toString(),
          "user_name": (extra['user_name'] ?? "").toString(),
          "profile_image": (extra['profile_image'] ?? "").toString(),
          "notification_status": (extra['notification_status'] ?? "").toString(),
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'pending_call_accept',
          jsonEncode(pendingCallArguments),
        );
        // Navigate immediately if app is open
        Utils.navigatorKey.currentState?.pushNamed(
          RoutesName.INCOMING_CALL_FULL_SCREEN,
          arguments: pendingCallArguments,
        );
        break;

      case Event.actionCallDecline:
      case Event.actionCallEnded:
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('pending_call_accept');
        pendingCallArguments = null;
        FlutterCallkitIncoming.endAllCalls();
        break;
      default:
        break;
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.startNetworkWatcher();
  AppLifeCycleTracker.instance.start();
  final fetchResult = await setup();
  final authToken = fetchResult["authToken"];
  final result = fetchResult["result"];
  NotificationService.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  _listenCallKitEvents();
  FirebaseMessaging.instance.getToken().then((value) {
    debugPrint("fcm:-$value" );
  },);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<SocialLoginCubit>(create: (context) => SocialLoginCubit()),
        BlocProvider<SignUpCubit>(create: ( context) => SignUpCubit()),
        BlocProvider<ResetPasswordCubit>(create: ( context) => ResetPasswordCubit()),
        BlocProvider<VerificationCodeCubit>(create: ( context) => VerificationCodeCubit()),
        BlocProvider<QuestionCubit>(create: ( context) => QuestionCubit()),
        BlocProvider<CardCubit>(create: ( context) => CardCubit()),
        BlocProvider<AnalysisCubit>(create: ( context) => AnalysisCubit()),
        BlocProvider<AnalysisCompleteCubit>(create: (context) => AnalysisCompleteCubit()),
        BlocProvider<OnboardingCubit>(create: ( context) => OnboardingCubit()),
        BlocProvider<CredibilityCubit>(create: (context) => CredibilityCubit()),
        BlocProvider<ChooseYourGoalsCubit>(create: ( context) => ChooseYourGoalsCubit()),
        BlocProvider<RatingCubit>(create: ( context) => RatingCubit()),
        BlocProvider<PostPaywallCubit>(create: ( context) => PostPaywallCubit()),
        BlocProvider<ListOfModuleCubit>(create: ( context) => ListOfModuleCubit()),
        BlocProvider<FavoriteMemoriesCubit>(create: (context) => FavoriteMemoriesCubit()),
        BlocProvider<AnswerCubit>(create: ( context) => AnswerCubit()),
        BlocProvider<LegacyWrappedCubit>(create: ( context) => LegacyWrappedCubit()),
        BlocProvider<SettingsCubit>(create: ( context) => SettingsCubit()),
        BlocProvider<PaywallCubit>(create: ( context) => PaywallCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<FriendsProfileCubit>(create: (context) => FriendsProfileCubit()),
        BlocProvider<EmailVerificationCubit>(create: (context) => EmailVerificationCubit()),
        BlocProvider<PodcastCubit>(create: (context) => PodcastCubit()),
        BlocProvider<MyPodcastCubit>(create: (context) => MyPodcastCubit()),
        BlocProvider<PodCastRecordingCubit>(create: (context) => PodCastRecordingCubit()),
        BlocProvider<AudioPreviewEditCubit>(create: (context) => AudioPreviewEditCubit()),
        BlocProvider<PlayPodcastCubit>(create: (context) => PlayPodcastCubit()),
        BlocProvider<CreateNewPodcastCubit>(create: (context) => CreateNewPodcastCubit()),
        BlocProvider<LiveKitConnectionCubit>(create: (context) => LiveKitConnectionCubit()),
      ],
      child:  MyApp(authToken:authToken,result:result),
    ),
  );
}

Future<Map<String, dynamic>> setup() async {
  await AppPreference().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  String authToken =  await AppPreference().get(key: AppPreference.KEY_USER_TOKEN);
  final result =  await AppPreference().getBool(key: AppPreference.KEY_SURVEY_SUBMITTED);
  final dir = await getApplicationDocumentsDirectory();
  await migrateCachedVideoDataToSharedPreferences();

  AppService.cachePath = "${dir.path}/dio_cache";
  if(authToken.isNotEmpty){
    ApiURL.authToken = authToken;
    AppService.initializeUserData();
  }

  print("isLoggedIn: $authToken");

  return {"authToken":authToken,"result":result};
}

class MyApp extends StatelessWidget {
  String authToken;
  bool result;
  MyApp({super.key,required this.authToken,required this.result});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    final botToastBuilder = BotToastInit();
    return MaterialApp(

      builder: (context, child) {
        child = botToastBuilder(context, child);
        return Stack(
          children: [
            child,
            TipDialogContainer(),
          ],
        );
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      navigatorKey: Utils.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      initialRoute:getInitialRoute(),
      onGenerateRoute: Routes.generateRoutes,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }

  String getInitialRoute() {
    if(authToken.isNotEmpty){
      ApiURL.authToken = authToken;
      AppService.initializeUserData();
      if(result){
        return RoutesName.HOME_SCREEN;
      }else{
        return RoutesName.QUESTION_SCREEN;
      }
    }else{
      return RoutesName.SPLASH_SCREEN;
    }
  }
}
