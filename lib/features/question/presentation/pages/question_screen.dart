import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_text_field.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_progress_bar.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/question/data/model/question.dart';
import 'package:legacy_sync/features/question/presentation/bloc/question_bloc/question_cubit.dart';
import 'package:legacy_sync/features/question/presentation/bloc/question_state/question_state.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final PageController _pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late final QuestionCubit _questionCubit;

  @override
  void initState() {
    super.initState();
    _questionCubit = context.read<QuestionCubit>();
    _questionCubit.getQuestionData();
  }

  @override
  void dispose() {
    // Stop speaking when leaving the screen
    _questionCubit.stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: SafeArea(
        child: KeyboardDismissOnTap(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(mainAxisSize: MainAxisSize.min, children: [const SizedBox(height: 24), _buildProgressBar(), const SizedBox(height: 12), _headingBar(), _buildBodyWidget()]),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<QuestionCubit, QuestionState>(
          listener: (context, state) {
            _pageController.animateToPage(state.currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          builder: (context, state) {
            return PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.queationList.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 3.height),
                    _buildQuestion(state.queationList[index].questiontext ?? ""),
                    SizedBox(height: 4.height),
                    _buildOptionView(index, state.queationList.length, state),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestion(String questionText) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: questionText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  height: 24,
                  width: 24,
                  margin: const EdgeInsets.only(left: 6),
                  child: AppButton(
                    onPressed: () {
                      if (state.isSpeaking) {
                        context.read<QuestionCubit>().stopSpeaking();
                      } else {
                        context.read<QuestionCubit>().startSpeaking(questionText);
                      }
                    },
                    child: SizedBox(height: 24, width: 24, child: Center(child: SvgPicture.asset(state.isSpeaking ? Images.ic_stop_speaker_svg : Images.ic_speker_svg, height: 24, width: 24))),
                  ),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget _headingBar() {
    return BlocConsumer<QuestionCubit, QuestionState>(
      listener: (context, state) {
        _pageController.animateToPage(state.currentPage, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      },
      builder: (context, state) {
        final questionCubit = context.read<QuestionCubit>();
        final canSkip = questionCubit.canSkipQuestion(state.currentPage);
        final isAnswered = questionCubit.isQuestionAnswered(state.currentPage);

        return LegacyAppBar(
          onBackPressed: () {
            context.read<QuestionCubit>().showPreviewQuestion(state.currentPage);
          },
          title: "${AppStrings.question} ${state.currentPage + 1}",
          actionWidget:
              canSkip
                  ? AppButton(
                    padding: const EdgeInsets.only(right: 16),
                    child: const Text(
                      AppStrings.skip, //isAnswered ? AppStrings.next : AppStrings.skip
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.grey400),
                    ),
                    onPressed: () {
                      context.read<QuestionCubit>().skipQuestion(state.currentPage);
                    },
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: GradientProgressBar(currentStep: state.currentPage + 1, totalSteps: state.queationList.length, height: 10));
      },
    );
  }

  Widget _buildOptionView(int index, int questionsSize, QuestionState state) {
    return index == state.queationList.length - 1 ? _buildAboutYouWidget(state) : _buildOptionList(index, state.queationList.length, state.queationList[index].options);
  }

  Widget _buildAboutYouWidget(QuestionState state) {
    // if (nameController.text != (state.userName ?? "")) {
    //   nameController.text = state.userName ?? "";
    // }

    // final name = state.userName ?? "";

    final nameIsVisible = state.nameIsAvailable;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: !nameIsVisible,
          child: CustomTextField(
            radias: 50,
            contentPaddingHorizontal: 16,
            hintText: AppStrings.name,
            controller: nameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              context.read<QuestionCubit>().updateUserName(value);
              context.read<QuestionCubit>().updateNameAndAge(name: value, age: ageController.text);
              context.read<QuestionCubit>().checkFormValidation(name: value, age: ageController.text);
            },
          ),
        ),
        BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            final bool isInvalidAge = state.error == "You must be at least 15 years old to use Legacy Sync.";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  radias: 50,
                  contentPaddingHorizontal: 16,
                  hintText: AppStrings.age,
                  controller: ageController,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  borderColor: isInvalidAge ? Colors.redAccent : AppColors.greyBlue,
                  bottomPadding: false,
                  onChanged: (value) {
                    context.read<QuestionCubit>().updateNameAndAge(name: nameController.text, age: value);
                    context.read<QuestionCubit>().checkFormValidation(name: nameController.text, age: value);
                  },
                ),
                if (isInvalidAge) ...[
                  const SizedBox(height: 6),
                  Padding(padding: const EdgeInsets.only(left: 16), child: Text(state.error ?? '', style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            return CustomButton(
              onPressed: () async {
                if (state.isFormValid) {
                  // Save the username to shared preferences
                  if (nameController.text.trim().isNotEmpty) {
                    await AppPreference().set(key: AppPreference.KEY_USER_FIRST_NAME, value: nameController.text.trim());
                  }
                  // Print current answers for debugging
                  context.read<QuestionCubit>().submitSurveyAnswers(context);
                  // Navigate to analysis screen or perform other actions
                }
              },
              isLoadingState: false,
              enable: state.isFormValid,
              btnText: AppStrings.completeQuiz,
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionList(int questionIndex, int questionsSize, List<Option>? options) {
    return Expanded(
      child: ListView.builder(
        itemCount: options?.length ?? 0,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final option = options![index];
          final isSelected = context.read<QuestionCubit>().state.selectedOptions[questionIndex] == index;
          return AppButton(
            onPressed: () {
              context.read<QuestionCubit>().optionSubmit(questionIndex, index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.primaryColorDull,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: isSelected ? AppColors.greenColor : AppColors.greyBlue, width: isSelected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Utils.getIconWidget(option.optioncode),
                  const SizedBox(width: 10),
                  Expanded(child: Text(option.option ?? "", style: Theme.of(context).textTheme.bodyMedium)),
                  const SizedBox(width: 10),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.greenColor : Colors.transparent,
                      border: Border.all(color: isSelected ? AppColors.greenColor : AppColors.greyBlue, width: 1.5),
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
