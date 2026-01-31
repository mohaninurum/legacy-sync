import 'package:flutter/material.dart';
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/typing_text.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart' show AppPreference;
import 'package:legacy_sync/services/app_service/app_service.dart';
import '../../../incoming_call_full_screen/incoming_call_full_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Map<String, dynamic>? launchArgs;

  @override
  void initState() {
    super.initState();
    // check if app launched via Incoming Call (Native Intent)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        launchArgs = args;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    //TODO
    // If launched via call, show IncomingCallScreen
    // if (launchArgs != null && launchArgs!['type'] == 'call') {
    //   return IncomingCallFullScreen();//roomId: launchArgs!['room_id']
    // }

    return Scaffold(
      body: BgImageStack(
        imagePath: Images.splash_bg_image,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                TypingText(
                  fullText: AppStrings.splash_text,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  durationPerChar: const Duration(milliseconds: 100),
                  onFinished: () async {
                    await Future.delayed(const Duration(seconds: 2));

                    String token = await AppPreference().get(key: AppPreference.KEY_USER_TOKEN);
                    if(token.isNotEmpty){
                      ApiURL.authToken = token;
                      AppService.initializeUserData();
                      final result =  await AppPreference().getBool(key: AppPreference.KEY_SURVEY_SUBMITTED);
                      if(result){
                        Navigator.pushNamedAndRemoveUntil(context, RoutesName.HOME_SCREEN, (Route<dynamic> route) => false);
                      }else{
                        Navigator.pushNamedAndRemoveUntil(context, RoutesName.QUESTION_SCREEN, (Route<dynamic> route) => false);
                      }
                    }else{
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesName.SOCIAL_LOGIN_SCREEN,
                            (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
