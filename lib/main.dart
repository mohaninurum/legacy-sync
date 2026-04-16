import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_video_player_plus/util/migration_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/config/routes/routes.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/config/theme/app_theme.dart';
import 'package:legacy_sync/core/app_sizes/app_sizes.dart';
import 'package:legacy_sync/core/navigation/route_observer.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_complete_cubit.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_cubit.dart';
import 'package:legacy_sync/features/answer/presentation/bloc/answer_bloc/answer_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/login_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/reset_password_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/signup_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/verification_code_cubit.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_bloc/card_cubit.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_cubit/create_new_podcast_cubit.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/list_of_module/list_of_module.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_state.dart';
import 'package:legacy_sync/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:legacy_sync/features/ongoing_call_overlay/on_going_call_overlay.dart';
import 'package:legacy_sync/features/post_paywall/presentation/bloc/post_paywall_cubit.dart';
import 'package:legacy_sync/features/question/presentation/bloc/question_bloc/question_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/choose_your_goals_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/credibility_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/rating_cubit.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';
import 'package:legacy_sync/services/notification_service/android_notification_channel.dart';
import 'package:legacy_sync/services/notification_service/notification_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'config/network/api_host.dart';
import 'features/auth/presentation/bloc/auth_bloc/email_verification_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc/social_login_cubit.dart';
import 'features/friends_profile/presentation/bloc/profile_bloc/friends_profile_cubit.dart';
import 'features/home/presentation/bloc/home_bloc/home_cubit.dart';
import 'features/legacy_wrapped/presentation/bloc/legacy_wrapped_bloc/legacy_wrapped_cubit.dart';
import 'features/my_podcast/presentation/bloc/my_podcast_cubit.dart';
import 'features/paywall/presentation/bloc/paywall_cubit.dart';
import 'features/play_podcast/presentation/bloc/play_podcast_cubit.dart';
import 'features/podcast/presentation/bloc/podcast_cubit.dart';
import 'features/podcast_recording/presentation/bloc/podcast_recording_cubit.dart';
import 'features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';
import 'firebase_options.dart';

Map<String, dynamic>? pendingCallArguments;

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppPreference().init();
  await AppNotificationChannels.init();

  final data = Map<String, dynamic>.from(message.data);
  final roomId = (data['room_id'] ?? '').toString().trim();
  final status = (data['notification_status'] ?? '').toString().trim();

  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Background data: $data');

  if (roomId.isEmpty) {
    debugPrint("Ignoring background push because room_id is empty");
    return;
  }

  if (status == "101") {
    debugPrint("Ending all calls in background (status 101)");
    await FlutterCallkitIncoming.endAllCalls();
    await AppPreference().clearByKey(key: 'pending_call_accept');
    return;
  }

  try {
    debugPrint("Before showCallkitIncoming for room: $roomId");

    final params = CallKitParams(
      id: roomId,
      nameCaller: (data["user_name"] ?? "Incoming Call").toString(),
      handle: roomId,
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      appName: 'Legacy Sync',
      extra: {
        "room_id": roomId,
        "user_id": (data["user_id"] ?? "").toString(),
        "user_name": (data["user_name"] ?? "").toString(),
        "profile_image": (data["profile_image"] ?? "").toString(),
        "notification_status": status,
      },
      android: const AndroidParams(
        isCustomNotification: true,
        isCustomSmallExNotification: true,
        isShowFullLockedScreen: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#09121F',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: 'call_channel', // ✅ Corrected to match ID
        missedCallNotificationChannelName: 'missed_call_channel',
        isShowCallID: false,
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        supportsDTMF: true,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    debugPrint("Triggering CallKit for: $roomId with channel: call_channel");
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    debugPrint("showCallkitIncoming executed successfully for room: $roomId");
  } catch (e) {
    debugPrint("Error showing CallKit: $e");
  }

  final args = {
    "incoming_call": true,
    "is_accepted": false,
    "room_id": roomId,
    "user_id": (data["user_id"] ?? "").toString(),
    "user_name": (data["user_name"] ?? "").toString(),
    "profile_image": (data["profile_image"] ?? "").toString(),
    "notification_status": status,
  };

  await AppPreference().set(key: "pending_call_accept", value: jsonEncode(args));
  debugPrint("Saved pending call in background: ${jsonEncode(args)}");
}

void _listenCallKitEvents() {
  FlutterCallkitIncoming.onEvent.listen((event) async {
    if (event == null) return;

    switch (event.event) {
      case Event.actionCallAccept:
        final body = Map<String, dynamic>.from(event.body ?? {});
        final extra = Map<String, dynamic>.from(body['extra'] ?? {});

        pendingCallArguments = {
          "incoming_call": true,
          "is_accepted": true,
          "room_id": (extra["room_id"] ?? "").toString(),
          "user_id": (extra["user_id"] ?? "").toString(),
          "user_name": (body['nameCaller'] ?? "").toString(),
          "profile_image": (extra['profile_image'] ?? "").toString(),
          "notification_status": (extra['notification_status'] ?? "").toString(),
        };

        print("Pending Call Arguments from main : ${jsonEncode(pendingCallArguments)}");
        await AppPreference().set(
          key: 'pending_call_accept',
          value: jsonEncode(pendingCallArguments),
        );

        if (Utils.navigatorKey.currentState != null) {
          Utils.navigatorKey.currentState?.pushNamed(
            RoutesName.INCOMING_CALL_FULL_SCREEN,
            arguments: pendingCallArguments,
          );
        }
        // // Navigate immediately if app is already open
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //
        // });
        break;

      case Event.actionCallDecline:
      case Event.actionCallEnded:
        // final myUserId = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
        // final pendingArgs = await AppPreference().get(key: "pending_call_accept");
        // if (pendingArgs.isNotEmpty) {
        //   final decodedArgs = jsonDecode(pendingArgs);
        //   final hostId = (decodedArgs["user_id"] ?? "").toString();
        //   final roomId = (decodedArgs["room_id"] ?? "").toString();
        //
        //   if (hostId != '') {
        //     // Invite-e cancels the invite from Host perspective
        //     // userId: Host, friendId: Invitee (Me)
        //     await LiveKitConnectionUseCases().cancelInviteToPodcast(
        //       userId: int.tryParse(hostId) ?? 0,
        //       friendId: myUserId,
        //       roomId: roomId,
        //     );
        //   }
        // }
        await AppPreference().clearByKey(key: 'pending_call_accept');
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

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppPreference().init();
  await AppNotificationChannels.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AppService.startNetworkWatcher();
  AppLifeCycleTracker.instance.start();

  await NotificationService.init();
  _listenCallKitEvents();

  final fetchResult = await setup();
  final authToken = fetchResult["authToken"];
  final result = fetchResult["result"];

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider<SocialLoginCubit>(create: (context) => SocialLoginCubit()),
        BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
        BlocProvider<ResetPasswordCubit>(create: (context) => ResetPasswordCubit()),
        BlocProvider<VerificationCodeCubit>(create: (context) => VerificationCodeCubit()),
        BlocProvider<QuestionCubit>(create: (context) => QuestionCubit()),
        BlocProvider<CardCubit>(create: (context) => CardCubit()),
        BlocProvider<AnalysisCubit>(create: (context) => AnalysisCubit()),
        BlocProvider<AnalysisCompleteCubit>(create: (context) => AnalysisCompleteCubit()),
        BlocProvider<OnboardingCubit>(create: (context) => OnboardingCubit()),
        BlocProvider<CredibilityCubit>(create: (context) => CredibilityCubit()),
        BlocProvider<ChooseYourGoalsCubit>(create: (context) => ChooseYourGoalsCubit()),
        BlocProvider<RatingCubit>(create: (context) => RatingCubit()),
        BlocProvider<PostPaywallCubit>(create: (context) => PostPaywallCubit()),
        BlocProvider<ListOfModuleCubit>(create: (context) => ListOfModuleCubit()),
        BlocProvider<FavoriteMemoriesCubit>(create: (context) => FavoriteMemoriesCubit()),
        BlocProvider<AnswerCubit>(create: (context) => AnswerCubit()),
        BlocProvider<LegacyWrappedCubit>(create: (context) => LegacyWrappedCubit()),
        BlocProvider<SettingsCubit>(create: (context) => SettingsCubit()),
        BlocProvider<PaywallCubit>(create: (context) => PaywallCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<FriendsProfileCubit>(create: (context) => FriendsProfileCubit()),
        BlocProvider<EmailVerificationCubit>(
          create: (context) => EmailVerificationCubit(),
        ),
        BlocProvider<PodcastCubit>(create: (context) => PodcastCubit()),
        BlocProvider<MyPodcastCubit>(create: (context) => MyPodcastCubit()),
        BlocProvider<PodCastRecordingCubit>(create: (context) => PodCastRecordingCubit()),
        BlocProvider<PlayPodcastCubit>(create: (context) => PlayPodcastCubit()),
        BlocProvider<CreateNewPodcastCubit>(create: (context) => CreateNewPodcastCubit()),
        BlocProvider<LiveKitConnectionCubit>(
          create: (context) => LiveKitConnectionCubit(),
        ),
      ],
      child: MyApp(authToken: authToken, result: result),
    ),
  );
}

Future<Map<String, dynamic>> setup() async {
  String authToken = await AppPreference().get(key: AppPreference.KEY_USER_TOKEN);
  final result = await AppPreference().getBool(key: AppPreference.KEY_SURVEY_SUBMITTED);
  final dir = await getApplicationDocumentsDirectory();
  await migrateCachedVideoDataToSharedPreferences();

  AppService.cachePath = "${dir.path}/dio_cache";
  if (authToken.isNotEmpty) {
    ApiURL.authToken = authToken;
    AppService.initializeUserData();
  }

  debugPrint("isLoggedIn: $authToken");

  return {"authToken": authToken, "result": result};
}

class MyApp extends StatelessWidget {
  String authToken;
  bool result;

  MyApp({super.key, required this.authToken, required this.result});

  static bool _routeBootstrapped = false;
  static bool _pendingCallChecked = false; // Add this

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    final botToastBuilder = BotToastInit();

    return MaterialApp(
      builder: (context, child) {
        child = botToastBuilder(context, child);
        // ✅ PLACE IT HERE (runs only once)
        if (!_routeBootstrapped) {
          _routeBootstrapped = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctx = Utils.navigatorKey.currentContext ?? context;
            final route = ModalRoute.of(ctx);
            if (route != null) AppRouteTracker.setRoute(route);
          });
        }

        if (!_pendingCallChecked) {
          _pendingCallChecked = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Give the app a moment to settle
            await Future.delayed(const Duration(milliseconds: 500));
            final pending = await AppPreference().get(key: 'pending_call_accept');
            if (pending.isNotEmpty) {
              try {
                final args = jsonDecode(pending);
                // Clear it so it doesn't fire again
                await AppPreference().clearByKey(key: 'pending_call_accept');

                debugPrint("Navigating to pending call: $args");
                Utils.navigatorKey.currentState?.pushNamed(
                  RoutesName.INCOMING_CALL_FULL_SCREEN,
                  arguments: args,
                );
              } catch (e) {
                debugPrint("Error parsing pending call: $e");
              }
            }
          });
        }

        return BlocListener<LiveKitConnectionCubit, LiveKitConnectionState>(
          listenWhen: (p, c) => p.navEvent != c.navEvent && !c.navEvent.isNone,
          listener: (context, state) {
            final nav = state.navEvent;
            final navKey = Utils.navigatorKey.currentState;

            // clear FIRST so it won't repeat
            context.read<LiveKitConnectionCubit>().clearNavEvent();

            if (navKey == null) return;

            if (nav.route == "AudioPreviewEditScreen") {
              navKey.pushNamed(
                RoutesName.AUDIO_PREVIEW_EDIT_SCREEN,
                arguments: nav.arguments,
              );
            } else {
              // replace stack to avoid back weirdness
              navKey.pushNamedAndRemoveUntil(RoutesName.MY_PODCAST_SCREEN, (r) => false);
            }
          },
          child: Stack(
            children: [child, TipDialogContainer(), const OngoingCallOverlay()],
          ),
        );
      },
      navigatorObservers: [BotToastNavigatorObserver(), AppRouteObserver()],
      navigatorKey: Utils.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      initialRoute: getInitialRoute(),
      onGenerateRoute: Routes.generateRoutes,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }

  String getInitialRoute() {
    if (authToken.isNotEmpty) {
      ApiURL.authToken = authToken;
      AppService.initializeUserData();
      if (result) {
        return RoutesName.HOME_SCREEN;
      } else {
        return RoutesName.QUESTION_SCREEN;
      }
    } else {
      return RoutesName.SPLASH_SCREEN;
    }
  }
}
