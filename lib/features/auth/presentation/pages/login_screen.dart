import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_text_field.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_text.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/social_button.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart' show Utils;
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/login_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/social_login_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: "mohan.inurum@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "Z&3quwje");
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    context.read<LoginCubit>().resetState();
    passwordFocusNode.addListener(() {
      context.read<LoginCubit>().onPasswordFocusChanged(
        passwordFocusNode.hasFocus,
      );
      // Trigger validation when focus changes to update info message visibility
      context.read<LoginCubit>().checkFormValidation(
        email: emailController.text,
        password: passwordController.text,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: LottieFiles.bg_login,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: KeyboardDismissOnTap(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLoginText(),
                    SizedBox(height: 4.height),
                    _buildLoginForm(context),
                    _buildForgotPasswordTextWidget(),
                    _buildLoginButton(context),
                    _buildSignupLink(context),
                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 0
                              : 5.height,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildDivider(), _buildSocialButton()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          icon: const Icon(Icons.apple_rounded, color: AppColors.grey),
          ontap: () {
            context.read<SocialLoginCubit>().signInWithApple(context: context);
          },
        ),
        SocialButton(
          icon: SizedBox(
            height: 24,
            width: 24,
            child: Image.asset(Images.ic_google),
          ),
          ontap: () {
            context.read<SocialLoginCubit>().signInWithGoogle(context: context);
          },
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const GradientDividerText(text: AppStrings.tryAnotherLoginOption);
  }

  Widget _buildForgotPasswordTextWidget() {
    return AppButton(
      child: const Text(
        AppStrings.forgotPassword,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RoutesName.RESET_PASSWORD_SCREEN);
      },
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hintText: AppStrings.enterYourEmail,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<LoginCubit>().checkFormValidation(
              email: emailController.text,
              password: passwordController.text,
            );
          },
        ),
        CustomTextField(
          hintText: AppStrings.enterPassword,
          controller: passwordController,
          focusNode: passwordFocusNode,
          isPassword: true,
          bottomPadding: false,
          onChanged: (value) {
            context.read<LoginCubit>().checkFormValidation(
              email: emailController.text,
              password: passwordController.text,
            );
          },
        ),
        _buildPasswordInfoMessage(),
      ],
    );
  }

  Widget _buildPasswordInfoMessage() {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: state.showPasswordInfo ? null : 0,
          child:
              state.showPasswordInfo
                  ? Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Password must be at least 8 characters with uppercase, lowercase, number and special character',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccessState) {
          final isSurveyCompleted = await AppPreference().getBool(
            key: AppPreference.KEY_SURVEY_SUBMITTED,
          );
          if (isSurveyCompleted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.CARD_SCREEN,
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.QUESTION_SCREEN,
              (Route<dynamic> route) => false,
            );
          }
        }
        if (state.loginSuccess != null &&
            !state.loginSuccess! &&
            state.error != null) {
          Utils.showInfoDialog(context: context, title: state.error!);
        }
      },
      builder: (context, state) {
        return CustomButton(
          onPressed: () {
            context.read<LoginCubit>().login(
              email: emailController.text,
              password: passwordController.text,
            );
          },
          isLoadingState: state.isLoading,
          enable: state.isFormValid,
          btnText: AppStrings.login,
        );
      },
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.youDoNotHaveAccount,
          style: TextStyle(color: AppColors.whiteColor, fontSize: 15),
        ),
        AppButton(
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.SIGN_UP_SCREEN);
          },
          child: const Text(
            AppStrings.signUp,
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

  Widget _buildLoginText() {
    return Center(
      child: Text(
        AppStrings.login,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
