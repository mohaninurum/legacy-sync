import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/will_pop_scope.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/social_login_cubit.dart';

class SocialLoginScreen extends StatefulWidget {
  const SocialLoginScreen({super.key});
  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: AppWillPopScope(
          child: BgImageStack(
            imagePath: LottieFiles.bg_social_login,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleText(),
                    SizedBox(height: 1.5.height),
                    _buildDescText(),
                    SizedBox(height: 3.height),
                    _buildLoginButton(context),
                    _buildLoginLink(context),
                    SizedBox(height: 1.height),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(Platform.isIOS)
        CustomButton(
          onPressed: () {
            context.read<SocialLoginCubit>().signInWithApple(context: context);
          },
          btnText: AppStrings.continue_with_apple,
          leftWidget: const Icon(Icons.apple, color: AppColors.grey, size: 26),
          bgTransparent: true,
          onlyBorder: true,
        ),
        const SizedBox(height: 12),
        CustomButton(
          onPressed: () {
            context.read<SocialLoginCubit>().signInWithGoogle(context: context);
          },
          btnText: AppStrings.continue_with_google,
          leftWidget: Image.asset(Images.ic_google, height: 24, width: 24),
          bgTransparent: true,
          onlyBorder: true,
        ),
        const SizedBox(height: 12),
        CustomButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.LOGIN_SCREEN);
          },
          btnText: AppStrings.continue_with_email,
          rightWidget: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
          ),
        ),
        // GradientInsetButton(onPressed: () {}, text: ""),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(color: AppColors.whiteColor, fontSize: 15),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.LOGIN_SCREEN);
          },
          child: const Text(
            AppStrings.login,
            style: TextStyle(
              color: AppColors.primaryColorDark,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescText() {
    return const Center(
      child: Text(
        AppStrings.join_families,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTitleText() {
    return Center(
      child: Text(
        AppStrings.become_a_legacy_builder,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
