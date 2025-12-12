import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/post_paywall/data/model/post_paywall_page.dart';
import 'package:legacy_sync/features/post_paywall/presentation/bloc/post_paywall_cubit.dart';
import 'package:legacy_sync/features/post_paywall/presentation/bloc/post_paywall_state.dart';
import 'package:lottie/lottie.dart';

class PostPaywallScreen extends StatefulWidget {
  const PostPaywallScreen({super.key});
  @override
  State<PostPaywallScreen> createState() => _PostPaywallScreenState();
}

class _PostPaywallScreenState extends State<PostPaywallScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    context.read<PostPaywallCubit>().loadPages();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<PostPaywallCubit, PostPaywallState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.pages.length,
                      onPageChanged: (index) => context.read<PostPaywallCubit>().setPage(index, totalPages: state.pages.length),
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

  Widget _buildBody({required PostPaywallPageModel page}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(),
              Text(page.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.whiteColor)),
              Text(page.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.whiteColor)),
            ],
          ),
          page.imagePath.contains(".json")? Lottie.asset(page.imagePath):Image.asset(page.imagePath, fit: BoxFit.contain, height: 38.height, width: 75.width),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return BlocBuilder<PostPaywallCubit, PostPaywallState>(
      builder: (context, state) {
        return SafeArea(
          minimum: const EdgeInsets.only(bottom: 40, left: 16, right: 16, top: 8),
          // padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16, top: 8),
          child: CustomButton(
            btnText: AppStrings.continueText,
            isLoadingState: false,
            enable: true,
            onPressed: () {
              if (state.isLastPage) {
                Navigator.pushNamed(context, RoutesName.HOME_SCREEN);
              } else {
                context.read<PostPaywallCubit>().next(totalPages: state.pages.length);
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }
            },
          ),
        );
      },
    );
  }
}
