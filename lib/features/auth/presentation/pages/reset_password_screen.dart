import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_text_field.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/reset_password_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ResetPasswordCubit>().resetState();
  }

  @override
  void dispose() {
    emailController.dispose();
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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: LegacyAppBar(),
          ),
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
                    _buildResetPasswordText(),
                    SizedBox(height: 4.height),
                    _buildEmailTextFiled(context),
                    _buildContinueButton(context),
                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 0
                              : 44.height,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextFiled(BuildContext context) {
    return CustomTextField(
      hintText: AppStrings.enterYourEmail,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        context.read<ResetPasswordCubit>().checkFormValidation(
          email: emailController.text,
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.otpSendSuccess) {
          Navigator.pushNamed(
            context,
            RoutesName.VERIFICATION_CODE_SCREEN,
            arguments: emailController.text,
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          isLoadingState: state.isLoading,
          enable: state.isFormValid,
          onPressed: () {
            if (state.isFormValid) {
              context.read<ResetPasswordCubit>().sendOtpOnEmail(email:emailController.text);
            }
          },
          btnText: AppStrings.sendEmailResetPassword,
        );
      },
    );
  }

  Widget _buildResetPasswordText() {
    return Center(
      child: Text(
        AppStrings.reset_password,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
