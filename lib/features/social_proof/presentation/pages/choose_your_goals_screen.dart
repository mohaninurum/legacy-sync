import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/features/social_proof/data/model/goal_item.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/choose_your_goals_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/choose_your_goals_state.dart';

class ChooseYourGoalsScreen extends StatefulWidget {
  const ChooseYourGoalsScreen({super.key});

  @override
  State<ChooseYourGoalsScreen> createState() => _ChooseYourGoalsScreenState();
}

class _ChooseYourGoalsScreenState extends State<ChooseYourGoalsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<ChooseYourGoalsCubit>().loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildAppBar(),
          ),
          body: _buildBody(),
          bottomNavigationBar: _buildButton(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildInstruction(),
            const SizedBox(height: 24),
            _buildGoalsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return BlocBuilder<ChooseYourGoalsCubit, ChooseYourGoalsState>(
      builder: (context, state) {
        return LegacyAppBar(
          title: AppStrings.chooseYourGoals,
          onBackPressed: () {
            Navigator.pop(context);
            if (state.isSpeaking) {
              context.read<ChooseYourGoalsCubit>().stopSpeaking();
            }
          },
        );
      },
    );
  }

  Widget _buildInstruction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<ChooseYourGoalsCubit, ChooseYourGoalsState>(
        builder: (context, state) {
          return Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: AppStrings.selectGoalsInstruction,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AppButton(
                    onPressed: () {
                      if (state.isSpeaking) {
                        context.read<ChooseYourGoalsCubit>().stopSpeaking();
                      } else {
                        context.read<ChooseYourGoalsCubit>().startSpeaking(
                          AppStrings.selectGoalsInstruction,
                        );
                      }
                    },
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: SvgPicture.asset(
                          state.isSpeaking
                              ? Images.ic_stop_speaker_svg
                              : Images.ic_speker_svg,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }

  Widget _buildGoalsList() {
    return BlocBuilder<ChooseYourGoalsCubit, ChooseYourGoalsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.whiteColor));
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.goals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final goal = state.goals[index];
            return _GoalCard(
              goal: goal,
              onTap: () {
                context.read<ChooseYourGoalsCubit>().toggleGoalSelection(
                  goal.goalIdPk,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildButton() {
    return BlocBuilder<ChooseYourGoalsCubit, ChooseYourGoalsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: CustomButton(
            onPressed: () {
              // TODO: Navigate to next screen or save goals
              if (state.hasSelectedGoals) {
                // Navigate to next screen
                if (state.isSpeaking) {
                  context.read<ChooseYourGoalsCubit>().stopSpeaking();
                }
                Navigator.pushNamed(context, RoutesName.RATING_SCREEN);
              }
            },
            enable: state.hasSelectedGoals,
            btnText: AppStrings.trackTheseGoals,
          ),
        );
      },
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalItem goal;
  final VoidCallback onTap;

  const _GoalCard({required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        goal.isSelected
            ? Utils.hexToColor(goal.activateBgColor)
            : Utils.hexToColor(goal.inactiveBgColorCode);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Goal icon placeholder (you can replace with actual icons)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    goal.isSelected
                        ? AppColors.whiteColor.withValues(alpha: 0.5)
                        : Utils.hexToColor(goal.iconColorCode),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Utils.getGoalIcons(goal.iconCode),
                  height: 18,
                  width: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                goal.goalTitle,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            // Selection indicator
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    goal.isSelected
                        ? AppColors.whiteColor
                        : AppColors.primaryColorDull,
              ),
              child:
                  goal.isSelected
                      ? const Icon(
                        Icons.check,
                        color: AppColors.blackColor,
                        size: 16,
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
