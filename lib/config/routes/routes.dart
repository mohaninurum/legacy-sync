import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/features/analysis/presentation/pages/analysis_screen.dart';
import 'package:legacy_sync/features/auth/presentation/pages/login_screen.dart';
import 'package:legacy_sync/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:legacy_sync/features/auth/presentation/pages/signup_screen.dart';
import 'package:legacy_sync/features/auth/presentation/pages/social_login_screen.dart';
import 'package:legacy_sync/features/auth/presentation/pages/verification_code_screen.dart';
import 'package:legacy_sync/features/card/presentation/pages/card_screen.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/pages/create_new_podcast_screen.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/pages/favorite_memories_screen.dart';
import 'package:legacy_sync/features/friends_profile/presentation/pages/friends_profile_page.dart';
import 'package:legacy_sync/features/home/presentation/pages/learn_page.dart';
import 'package:legacy_sync/features/list_of_module/presentation/pages/list_of_module_screen.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/pages/podcast_connection.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/pages/room.dart';
import 'package:legacy_sync/features/question/presentation/pages/question_screen.dart';
import 'package:legacy_sync/features/settings/presentation/pages/f_a_q_screen.dart';
import 'package:legacy_sync/features/social_proof/presentation/pages/choose_your_goals_screen.dart';
import 'package:legacy_sync/features/splash/presentation/pages/splash_screen.dart';
import 'package:legacy_sync/features/analysis/presentation/pages/analysis_complete_screen.dart';
import 'package:legacy_sync/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:legacy_sync/features/social_proof/presentation/pages/credibility_screen.dart';
import 'package:legacy_sync/features/social_proof/presentation/pages/rating_screen.dart';
import 'package:legacy_sync/features/card/presentation/pages/welcome_card_screen.dart';
import 'package:legacy_sync/features/post_paywall/presentation/pages/post_paywall_screen.dart';
import 'package:legacy_sync/features/paywall/presentation/pages/paywall_screen.dart';
import 'package:legacy_sync/features/answer/presentation/pages/answer_screen.dart';

import '../../features/audio_preview_edit/presentation/pages/audio_preview_edit_screen.dart';
import '../../features/auth/presentation/pages/email_verification_screen.dart';
import '../../features/incoming_call_full_screen/incoming_call_full_screen.dart';
import '../../features/legacy_wrapped/presentation/pages/legacy_wrapped_screen.dart';
import '../../features/legacy_wrapped/presentation/pages/voice_is_growing_screen.dart';
import '../../features/my_podcast/presentation/pages/my_podcast_screen.dart';
import '../../features/play_podcast/presentation/pages/play_podcast.dart';
import '../../features/play_podcast/presentation/pages/widget/transcript_description.dart';
import '../../features/podcast/presentation/pages/podcast_screen.dart';
import '../../features/podcast_recording/presentation/pages/podcast_recording_screen.dart';
import '../../features/settings/presentation/pages/more_options_screen.dart';
import '../../features/settings/presentation/pages/support_screen.dart';
import '../../features/settings/presentation/pages/notifications_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/bloc/home_bloc/home_cubit.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.SPLASH_SCREEN:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesName.RESET_PASSWORD_SCREEN:
        return _animatedRouteRightToLeft(const ResetPasswordScreen());
      case RoutesName.VERIFICATION_CODE_SCREEN:
        final email = settings.arguments as String?;
        return _animatedRouteRightToLeft(
          VerificationCodeScreen(email: email ?? ""),
        );
      case RoutesName.email_verification_screen:
        final email = settings.arguments as String?;
        return _animatedRouteRightToLeft(
          EmailVerificationScreen(email: email ?? ""),
        );
      case RoutesName.LOGIN_SCREEN:
        return _animatedRouteRightToLeft(const LoginScreen());
      case RoutesName.SOCIAL_LOGIN_SCREEN:
        return _animatedRouteRightToLeft(const SocialLoginScreen());
      case RoutesName.SIGN_UP_SCREEN:
        return _animatedRouteRightToLeft(const SignUpScreen());
      case RoutesName.QUESTION_SCREEN:
        return _animatedRouteRightToLeft(const QuestionScreen());
      case RoutesName.FAVORITE_MEMORIES_SCREEN:
        return _animatedRouteRightToLeft(const FavoriteMemories());

      case RoutesName.FAQ_SCREEN:
        return _animatedRouteRightToLeft(const FAQScreen());
      case RoutesName.CARD_SCREEN:
        final args = settings.arguments as Map<String, dynamic>?;
        final hide_c_btn = args?['hide_c_btn'] as bool? ?? false;

        // hide_c_btn
        return _animatedRouteZoomOut(
          CardScreen(hideContinueButton: hide_c_btn),
        );

      case RoutesName.FRIENDS_PROFILE_PAGE:
        final args = settings.arguments as Map<String, dynamic>?;
        final friendId = args?['friendId'] as int? ?? 0;

        return _animatedRouteZoomOut(FriendsProfilePage(friendId: friendId));
      case RoutesName.ANALYSIS_SCREEN:
        return _animatedRouteZoomOut(const AnalysisScreen());

      case RoutesName.LEARN_PAGE:
        return _animatedRouteDownToUp(const LearnPage());
      case RoutesName.LIST_OF_MODULE:
        final args = settings.arguments as Map<String, dynamic>?;
        final moduleId = args?['moduleId'] as int? ?? 1;
        final friendId = args?['friendId'] as int? ?? 0;
        final moduleTitle = args?['moduleTitle'] as String? ?? '';
        final moduleImage = args?['moduleImage'] as String? ?? '';
        final fromFriends = args?['fromFriends'] as bool? ?? false;
        final preExpanded = args?['preExpanded'] as bool? ?? false;

        print("Routes - Received arguments:");
        print("Module ID: $moduleId");
        print("Module Title: '$moduleTitle'");
        print("Module Image: '$moduleImage'");

        return _animatedRouteZoomOut(
          ListOfModuleScreen(
            moduleId: moduleId,
            moduleTitle: moduleTitle,
            moduleImage: moduleImage,
            fromFriends: fromFriends,
            friendId: friendId,
            preExpanded: preExpanded,
          ),
        );
      case RoutesName.ANALYSIS_COMPLETE_SCREEN:
        return _animatedRouteRightToLeft(const AnalysisCompleteScreen());
      case RoutesName.ONBOARDING_SCREEN:
        return _animatedRouteRightToLeft(const OnboardingScreen());
      case RoutesName.CREDIBILITY_SCREEN:
        return _animatedRouteRightToLeft(const CredibilityScreen());

      case RoutesName.SETTING_MORE_OPTIONS_SCREEN:
        return _animatedRouteRightToLeft(const MoreOptionsScreen());
      case RoutesName.SUPPORT_SCREEN:
        return _animatedRouteRightToLeft(const SupportScreen());
      case RoutesName.NOTIFICATIONS_SCREEN:
        return _animatedRouteRightToLeft(const NotificationsScreen());
      case RoutesName.HOME_SCREEN:
        return _animatedRouteZoomOut(
          BlocProvider(
            create: (context) => HomeCubit(),
            child: const HomeScreen(),
          ),
        );
      case RoutesName.CHOOSE_YOUR_GOALS_SCREEN:
        return _animatedRouteRightToLeft(const ChooseYourGoalsScreen());
      case RoutesName.RATING_SCREEN:
        return _animatedRouteRightToLeft(const RatingScreen());
      case RoutesName.WELCOME_CARD_SCREEN:
        return _animatedRouteRightToLeft(const WelcomeCardScreen());
      case RoutesName.POST_PAYWALL_SCREEN:
        return _animatedRouteRightToLeft(const PostPaywallScreen());
      case RoutesName.PAYWALL_SCREEN:
        return _animatedRouteRightToLeft(const PaywallScreen());
      case RoutesName.ANSWER_SCREEN:
        final data = settings.arguments as Map?;
        final qId = data!["qId"];
        final mIndex = data!["mIndex"];
        final questionText = data!["questionText"];
        final moduleIndex = data!["moduleIndex"];
        return _animatedRouteDownToUp(
          AnswerScreen(
            qId: qId ?? 0,
            mIndex: mIndex ?? 0,
            questionText: questionText ?? "",
            moduleIndex: moduleIndex ?? 1,
          ),
        );
      case RoutesName.LEGACY_WRAPPED_SCREEN:
        return _animatedRouteDownToUp(const LegacyWrappedScreen());
      case RoutesName.VOICE_GROWING_SCREEN:
        return _animatedRouteDownToUp(const VoiceIsGrowingScreen());
      case RoutesName.SETTINGS_SCREEN:
        return _animatedRouteRightToLeft(const SettingsScreen());
      case RoutesName.PROFILE_SCREEN:
        return _animatedRouteRightToLeft(const ProfilePage());
      case RoutesName.EDIT_PROFILE_SCREEN:
        return _animatedRouteRightToLeft(const EditProfilePage());
      case RoutesName.PODCAST_SCREEN:
        return _animatedRouteRightToLeft(const PodcastScreen());
      case RoutesName.ROOM_PAGE:
        final args = settings.arguments as Map<String, dynamic>?;
        final roomId = args?['roomId'] as String? ?? '';

        final incomingCall = args!["incoming_call"];
        final userName = args["userName"];
        final userId = args["userId"] as int? ?? -1;

        print("Routes - Received arguments:");
        print("room Id: $roomId");
        print("incomingCall : $incomingCall");
        print("userName : $userName");
        print("userId : $userId");

        return _animatedRouteZoomOut(
          BlocProvider(
            create: (context) => LiveKitConnectionCubit(),
            child: RoomPage(
              roomId: roomId,
              incomingCall: incomingCall,
              userName: userName,
              userId: userId,
            ),
          ),
        );
      // case RoutesName.PODCAST_CONNECTION:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   final roomId = args?['roomId'] as String? ?? '';
      //   final podcastId = args?['podcastId'] as int? ?? -1;
      //
      //   final incomingCall = args!["incoming_call"];
      //   final userName = args["userName"];
      //   final userId = args["userId"] as int? ?? -1;
      //
      //   print("Routes - Received arguments:");
      //   print("room Id: $roomId");
      //   print("podcast Id: $podcastId");
      //   print("incomingCall : $incomingCall");
      //   print("userName : $userName");
      //   print("userId : $userId");
      //
      //   return _animatedRouteZoomOut(
      //     PodcastConnection(
      //       roomId: roomId,
      //       podcastId: podcastId,
      //       incomingCall: incomingCall,
      //       userName: userName,
      //       userId: userId,
      //     ),
      //   );

      case RoutesName.MY_PODCAST_SCREEN:
        // final data = settings.arguments as Map?;
        // final incomingCall = data!["isStartFirstTime"];
        return _animatedRouteRightToLeft(
          const MyPodcastScreen(),
        );
      case RoutesName.PODCAST_RECORDING_SCREEN:
        final data = settings.arguments as Map?;
        final incomingCall = data!["incoming_call"];
        final userName = data["userName"];
        return _animatedRouteDownToUp(
          PodcastRecordingScreen(
            isIncomingCall: incomingCall,
            userName: userName,
          ),
        );
      case RoutesName.AUDIO_PREVIEW_EDIT_SCREEN:
        final data = settings.arguments as Map?;
        final podcastModel = data?["podcastModel"];
        final isDraft = data?["is_draft"];
        final participants = data?["participants"];
        final roomId = data?["roomId"] ?? '';

        return _animatedRouteDownToUp(
          AudioPreviewEditScreen(
            podcastModel: podcastModel,
            isDraft: isDraft,
            participants: participants,
            roomId: roomId,
          ),
        );

      // case RoutesName.INCOMING_CALL_FULL_SCREEN:
      //   return _animatedRouteDownToUp(const IncomingCallFullScreen());

      case RoutesName.INCOMING_CALL_FULL_SCREEN:
        final raw = settings.arguments as Map<dynamic, dynamic>? ?? {};

        final incomingCall =
            raw["incoming_call"] == true ||
            raw["incoming_call"]?.toString() == "true";
        final roomId = (raw["room_id"] ?? raw["roomId"] ?? "").toString();
        final callerUserId =
            (raw["user_id"] ?? raw["callerUserId"] ?? "").toString();
        final callerUserName =
            (raw["user_name"] ?? raw["callerUserName"] ?? "").toString();
        final callerProfileImage =
            (raw["profile_image"] ?? raw["callerProfileImage"] ?? "")
                .toString();
        final notificationStatus =
            (raw["notification_status"] ?? "").toString();

        return _animatedRouteDownToUp(
          IncomingCallFullScreen(
            incomingCall: incomingCall,
            roomId: roomId,
            callerProfileImage: callerProfileImage,
            callerUserId: callerUserId,
            callerUserName: callerUserName,
            notificationStatus: notificationStatus,
          ),
        );

      case RoutesName.PLAY_PODCAST:
        final data = settings.arguments as Map?;
        final podcast = data!["podcast"];
        final audioPath = data["audioPath"];
        final isOverlayManager = data["isOverlayManager"];
        final isContinue = data["isContinue"];
        final isFavorite = data["isFavorite"];
        return _animatedRouteDownToUp(
          PlayPodcast(
            podcast: podcast,
            audioPath: audioPath,
            isOverlayManager: isOverlayManager,
            isContinue: isContinue,
            isFavorite: isFavorite,
          ),
        );
      case RoutesName.transcript_description:
        final data = settings.arguments as Map?;
        final podcast = data!["podcast"];
        return _animatedRouteDownToUp(TranscriptDescription(podcast: podcast));

      case RoutesName.CREATE_NEW_PODCAST:
        return _animatedRouteRightToLeft(const CreateNewPodcastScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }

  // 👇 Right-to-left slide transition
  static Route _animatedRouteRightToLeft(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // start from right
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static Route _animatedRouteZoomOut(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)); // smoother zoom
        final fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  static Route _animatedRouteDownToUp(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: const Offset(0, 1), // start from bottom
          end: Offset.zero, // move to normal position
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        );
      },
    );
  }
}
