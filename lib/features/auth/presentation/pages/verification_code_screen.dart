import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/verification_code_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/verification_code_state.dart';
import 'package:pinput/pinput.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';

// ignore: must_be_immutable
class VerificationCodeScreen extends StatefulWidget {
  String email;
  VerificationCodeScreen({super.key, this.email = ''});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    context.read<VerificationCodeCubit>().resetState();
    context.read<VerificationCodeCubit>().startRemainingTimer();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
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
                    _buildTitleText(),
                    const SizedBox(height: 15),
                    _buildDescText(),
                    SizedBox(height: 4.height),
                    _buildEnter6DigitCodeText(),
                    const SizedBox(height: 14),
                    _buildOtpFiled(context),
                    const SizedBox(height: 12),
                    _buildDidNotRecivedEmailText(),
                    SizedBox(height: 6.height),
                    _buildContinueButton(context),
                    SizedBox(height: 20.height),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFiled(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 16.width,
      height: 7.height,
      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 20,
        color: AppColors.whiteColor,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColorDull,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyBlue, width: 1),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryColorDull,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.whiteColor, width: 1),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryColorDull,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 1),
      ),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primaryColorDull,
        border: Border.all(color: AppColors.whiteColor, width: 1),
      ),
    );
    return Pinput(
      length: 6,
      controller: pinController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      keyboardType: TextInputType.phone,
      errorPinTheme: errorPinTheme,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      forceErrorState: false,
      separatorBuilder: (index) => 2.kw,
      onChanged: (pin) {
        context.read<VerificationCodeCubit>().checkOTPFilled(
          pinController.text,
        );
      },
      onCompleted: (pin) {
        context.read<VerificationCodeCubit>().checkOTPFilled(
          pinController.text,
        );
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 2, height: 20, color: AppColors.whiteColor),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return BlocConsumer<VerificationCodeCubit, VerificationCodeState>(
      listener: (context, state) {
        if (!(MediaQuery.of(context).viewInsets.bottom > 0)) {
          context.read<VerificationCodeCubit>().checkOTPFilled(
            pinController.text,
          );
        }
        if (state is OTPValidState) {
          Utils.showInfoDialog(
            context: context,
            title: AppStrings.password_reset,
            content: AppStrings.your_password_has_been_changed,
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.LOGIN_SCREEN,
                (Route<dynamic> route) => false,
              );
            },
          );
        } else if (state is OTPEnvalidState) {
          Utils.showInfoDialog(
            context: context,
            title: AppStrings.invalidOTP,
            content: AppStrings.checkEmailAndEnterCorrectOTP,
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          isShadows: true,
          enable: state.buttonIsEnable,
          isLoadingState: state.loading,
          onPressed: () {
            context.read<VerificationCodeCubit>().checkOTPIsValid(email: widget.email,pin: pinController.text);
          },
          btnText: AppStrings.sendEmailResetPassword,
        );
      },
    );
  }

  Widget _buildDescText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          children: [
            const TextSpan(
              text: AppStrings.we_have_sent_a_code_to,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            TextSpan(
              text: widget.email,
              style: const TextStyle(color: AppColors.yellow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnter6DigitCodeText() {
    return const Text(
      AppStrings.enter_6_digit_code,
      style: TextStyle(color: AppColors.whiteColor, fontSize: 12),
    );
  }

  Widget _buildDidNotRecivedEmailText() {
    return AppButton(
      onPressed: () {
        Utils.showRemainingSecondsDialog(
          context: context,
          email: widget.email,
          title: AppStrings.did_not_receive_an_email,
          onPressed: () {
            context.read<VerificationCodeCubit>().startRemainingTimer();
          },
        );
      },
      child: const Text(
        AppStrings.i_did_not_receive_an_email,
        style: TextStyle(color: AppColors.whiteColor, fontSize: 12),
      ),
    );
  }

  Widget _buildTitleText() {
    return Center(
      child: Text(
        AppStrings.enter_the_verification_code,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
