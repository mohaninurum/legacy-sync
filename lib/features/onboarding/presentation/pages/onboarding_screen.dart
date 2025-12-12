import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/onboarding/data/model/onboarding_page.dart';
import 'package:legacy_sync/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:legacy_sync/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    context.read<OnboardingCubit>().loadPages();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.onboardingBg,
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: state.pages.length,
                    onPageChanged: (index) => context.read<OnboardingCubit>().setPage(index, totalPages: state.pages.length),
                    itemBuilder: (context, index) => _buildBody(page: state.pages[index]),
                  ),
                ),
                _buildDotsIndicator(currentIndex: state.currentPageIndex, total: state.pages.length),
              ],
            );
          },
        ),

        bottomNavigationBar: _buildButton(),
      ),
    );
  }

  Widget _buildDotsIndicator({required int currentIndex, required int total}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: isActive ? AppColors.whiteColor : AppColors.grey, borderRadius: BorderRadius.circular(8)),
          );
        }),
      ),
    );
  }

  Widget _buildBody({required OnboardingPageModel page}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 14.height),
          Lottie.asset(page.imagePath, fit: BoxFit.contain),
          Text(page.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blackColor)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: page.description, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppColors.blackColor)),
                TextSpan(text: page.richText, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppColors.blackColor, fontWeight: FontWeight.bold)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return SafeArea(
          minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 16,top: 3),
          // padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 8),
          child: CustomButton(
            btnText: AppStrings.continueText,
            isLoadingState: false,
            enable: true,
            onPressed: () {
              if (state.isLastPage) {
                Navigator.pushNamed(context, RoutesName.CREDIBILITY_SCREEN);
              } else {
                context.read<OnboardingCubit>().next(totalPages: state.pages.length);
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }
            },
          ),
        );
      },
    );
  }
}
