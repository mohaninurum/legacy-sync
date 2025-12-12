import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_progress_bar_red_and_blak.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/legacy_wrapped/data/model/legacy_wrapped_page.dart';
import 'package:legacy_sync/features/legacy_wrapped/presentation/bloc/legacy_wrapped_bloc/legacy_wrapped_cubit.dart';
import 'package:legacy_sync/features/legacy_wrapped/presentation/bloc/state/legacy_wrapped_state.dart';
import 'package:lottie/lottie.dart';

class LegacyWrappedScreen extends StatefulWidget {
  const LegacyWrappedScreen({super.key});

  @override
  State<LegacyWrappedScreen> createState() => _LegacyWrappedScreenState();
}

class _LegacyWrappedScreenState extends State<LegacyWrappedScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    context.read<LegacyWrappedCubit>().loadPages();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(

        child: BlocBuilder<LegacyWrappedCubit, LegacyWrappedState>(
          builder: (context, state) {
            return PageView.builder(controller: _pageController, itemCount: state.pages.length, onPageChanged: (index) => context.read<LegacyWrappedCubit>().setPage(index, totalPages: state.pages.length), itemBuilder: (context, index) => _buildBody(page: state.pages[index]));
          },
        ),
      ),

      bottomNavigationBar: _buildButton(),
    );
  }

  Widget _buildBody({required LegacyWrappedPageModel page}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.height),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(page.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blackColor))),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(page.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: AppColors.blackColor, fontWeight: FontWeight.w900))),
          const SizedBox(height: 16),
          page.childListing ? _buildListingWidget(page.data) : Lottie.asset(page.imagePath, fit: BoxFit.contain),//Image.asset(page.imagePath, fit: BoxFit.contain)
        ],
      ),
    );
  }

  Widget _buildListingWidget(List<WData> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.yellow, width: 1.5)),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildListItem(data[index]);
        },
      ),
    );
  }

  Widget _buildListItem(WData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(data.imagePath, height: 32, width: 32),
       const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(data.title, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.blackColor,letterSpacing: 0,height: 1)),
              const SizedBox(height: 2),
              Text(data.description, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, color: AppColors.blackColor, fontWeight: FontWeight.w500,letterSpacing: 0,height: 1)),
              const SizedBox(height: 10),
              GradientProgressBarReadAndBlackColor(currentStep: 3,totalSteps: 10,height: 6,),
              const SizedBox(height: 25),
            ],

          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return BlocBuilder<LegacyWrappedCubit, LegacyWrappedState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16, top: 8),
          child: CustomButton(
            btnText: AppStrings.continueText,
            isLoadingState: false,
            enable: true,
            onPressed: () {
              if (state.isLastPage) {
                 Navigator.pushNamed(context, RoutesName.VOICE_GROWING_SCREEN);
              } else {
                context.read<LegacyWrappedCubit>().next(totalPages: state.pages.length);
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }
            },
          ),
        );
      },
    );
  }
}
