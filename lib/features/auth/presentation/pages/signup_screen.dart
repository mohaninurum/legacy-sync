import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
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
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/signup_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_bloc/social_login_cubit.dart';
import 'package:legacy_sync/features/auth/presentation/bloc/auth_state/signup_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  DateTime? selectedDate;
  final DateTime currentDate = DateTime.now();
  late final DateTime minimumDate;
  late final DateTime maximumDate;

  @override
  void initState() {
    context.read<SignUpCubit>().resetState();
    passwordFocusNode.addListener(() {
      context.read<SignUpCubit>().onPasswordFocusChanged(
        passwordFocusNode.hasFocus,
      );
      // Trigger validation when focus changes to update info message visibility
      context.read<SignUpCubit>().checkFormValidation(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        dob: dobController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
    });
    confirmPasswordFocusNode.addListener(() {
      context.read<SignUpCubit>().onConfirmPasswordFocusChanged(
        confirmPasswordFocusNode.hasFocus,
      );
      // Trigger validation when focus changes to update info message visibility
      context.read<SignUpCubit>().checkFormValidation(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        dob: dobController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
    });
    context.read<SignUpCubit>().checkFormValidation(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      dob: dobController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    final now = DateTime.now();
    minimumDate = DateTime(now.year - 100, now.month, now.day);
    maximumDate = DateTime(now.year - 18, now.month, now.day);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _clearDateSelection() {
    setState(() {
      selectedDate = null;
      dobController.clear();
    });
    // Trigger form validation after clearing
    context.read<SignUpCubit>().checkFormValidation(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      dob: dobController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
  }

  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Material(
            child: Container(
              height: 350,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Header with title and done button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: CupertinoColors.systemBlue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Text(
                            'Select Date of Birth',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Ensure validation is triggered when done is pressed
                              if (selectedDate != null) {
                                context.read<SignUpCubit>().checkFormValidation(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  dob: dobController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: CupertinoColors.systemBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Age requirement info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: const Text(
                        'Must be at least 18 years old',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Date picker
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: selectedDate ?? maximumDate,
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate = newDate;
                            dobController.text = _formatDate(newDate);
                          });
                          // Trigger form validation immediately when date changes
                          context.read<SignUpCubit>().checkFormValidation(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            dob: dobController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    // Check if birthday has occurred this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: LottieFiles.bg_login,
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: KeyboardDismissOnTap(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSignUpText(),
                    SizedBox(height: 2.height),
                    _buildSignUpForm(context),
                    const SizedBox(height: 16),
                    _buildSignUpButton(context),
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
              children: [_buildDivider(), __buildSocialButton()],
            ),
          ),
        ),
      ),
    );
  }

  Widget __buildSocialButton() {
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

  Widget _buildSignUpForm(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: AppStrings.firstName,
                controller: firstNameController,
                onChanged: (value) {
                  context.read<SignUpCubit>().checkFormValidation(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    dob: dobController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextField(
                hintText: AppStrings.lastName,
                controller: lastNameController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<SignUpCubit>().checkFormValidation(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    dob: dobController.text,
                    password: passwordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                },
              ),
            ),
          ],
        ),
        CustomTextField(
          hintText: AppStrings.enterYourEmail,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            context.read<SignUpCubit>().checkFormValidation(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              dob: dobController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            );
          },
        ),
        CustomTextField(
          enabled: false,
          hintText: AppStrings.dateOfBirth,
          controller: dobController,
          keyboardType: TextInputType.emailAddress,
          suffixImageWidgetPathSVG: Images.ic_calender_svg,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            _showDatePicker();
          },
          onChanged: (value) {
            context.read<SignUpCubit>().checkFormValidation(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              dob: dobController.text,
              password: passwordController.text,
              confirmPassword: confirmPasswordController.text,
            );
          },
        ),

        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: AppStrings.enterPassword,
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    isPassword: true,
                    bottomPadding: false,
                    onChanged: (value) {
                      context.read<SignUpCubit>().checkFormValidation(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        dob: dobController.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: AppStrings.confirmPassword,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        isPassword: true,
                        bottomPadding: false,
                        onChanged: (value) {
                          context.read<SignUpCubit>().checkFormValidation(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            email: emailController.text,
                            dob: dobController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildPasswordInfoMessage(),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordInfoMessage() {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: state.showPasswordInfo || state.showConfirmPasswordInfo ? null : 0,
          child:
              state.showPasswordInfo || state.showConfirmPasswordInfo
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
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.red, size: 16),
                        const  SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.showPasswordInfo? 'Password must be at least 8 characters with uppercase, lowercase, number and special character':"Passwords do not match",
                            style:const TextStyle(
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


  Widget _buildSignUpButton(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if(state is SignUpSuccessState ){
          Navigator.pushNamed(
            context,
            RoutesName.email_verification_screen,
            arguments: emailController.text
          );
        }
        // if (state is SignUpSuccessState) {
        //   Navigator.pushNamedAndRemoveUntil(
        //     context,
        //     RoutesName.QUESTION_SCREEN,
        //     (Route<dynamic> route) => false,
        //   );
        // }
        if (state.signUpSuccess != null &&
            !state.signUpSuccess! &&
            state.error != null) {
          Utils.showInfoDialog(
            context: context,
            content: state.error!,
            title: "",
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          onPressed: () {
            if (state.isFormValid) {
              context.read<SignUpCubit>().signup(
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                dob: dobController.text,
                password: passwordController.text,
                confirmPassword: confirmPasswordController.text,
              );
            }
          },
          isLoadingState: state.isLoading,
          enable: state.isFormValid,
          btnText: AppStrings.signUp,
        );
      },
    );
  }

  Widget _buildSignupLink(BuildContext context) {
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
            Navigator.pop(context);
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

  Widget _buildSignUpText() {
    return Center(
      child: Text(
        AppStrings.signUp,
        style: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
