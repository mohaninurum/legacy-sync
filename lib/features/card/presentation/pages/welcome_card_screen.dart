import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/components/comman_components/typing_text.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_bloc/card_cubit.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_state/card_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart' show AppService;
import 'package:lottie/lottie.dart';

// ignore: use_build_context_synchronously
// ignore: unused_field
class WelcomeCardScreen extends StatefulWidget {
  const WelcomeCardScreen({super.key});

  @override
  State<WelcomeCardScreen> createState() => _WelcomeCardScreenState();
}

class _WelcomeCardScreenState extends State<WelcomeCardScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late List<AnimationController> _gridItemControllers;
  late List<Animation<double>> _gridItemAnimations;

  bool hideContinueButton=false;

  @override
  void initState() {
    hideContinueButton=false;
    super.initState();
    context.read<CardCubit>().loadTextList();
    context.read<CardCubit>().loadCard();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInitialCard();
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _slideController, curve: Curves.bounceOut));
    _scaleController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _showInitialCard() {
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: BlocBuilder<CardCubit, CardLoaded>(
              builder: (context, state) {
                return LegacyAppBar(
                  showBackButton: state.showCustomization?true:hideContinueButton?true: false,
                  onBackPressed: () {
                    if (state.showCustomization) {
                      context.read<CardCubit>().hideCustomization();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          body: BlocBuilder<CardCubit, CardLoaded>(
            builder: (context, state) {
              if (state.showCard) {
                return _buildWelcomeContent(state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          bottomNavigationBar: _buildContinueButton(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<CardCubit, CardLoaded>(
  builder: (context, state) {
    if ((state.textsList.length - 1 == state.curentIndex) == false) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '"The best time to plant a tree was 20 years ago. The second best time is now." ~ Chinese Proverb',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.PAYWALL_SCREEN);
              },
              btnText: "Continue",
            ),
          ),
        ],
      ),
    );
  },
);
  }

  Widget _headingBar() {
    return BlocBuilder<CardCubit, CardLoaded>(
      builder: (context, state) {
        if (state.textsList.length - 1 == state.curentIndex) {
          return const SizedBox.shrink();
        }
        return LegacyAppBar(
          showBackButton: false,
          actionWidget: AppButton(
            padding: const EdgeInsets.only(right: 16),
            child: const Text(AppStrings.skip, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.grey400)),
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.PAYWALL_SCREEN);
            },
          ),
        );
      },
    );
  }

  Widget _buildWelcomeContent(CardLoaded state) {
    return SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(children: [

      _headingBar(),
      if (!state.showCustomization) const SizedBox(height: 10),
      _buildWelcomeTitle(state),
      if (state.showCustomization) _buildCustomizationGrid(state),
    ]));
  }



  Widget _buildWelcomeTitle(CardLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<CardCubit, CardLoaded>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TypingText(
                key: ValueKey(state.curentIndex),
                fullText: state.showCustomization ? "Customize your card": state.textsList.isNotEmpty ? state.textsList[state.curentIndex] : "",
                textStyle: Theme.of(context).textTheme.bodyLarge,
                durationPerChar: const Duration(milliseconds: 80),
                onFinished: () async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (state.curentIndex < state.lastIndex) {
                    context.read<CardCubit>().changeText(state.curentIndex);
                  } else {
                    // Navigator.pushNamed(context, RoutesName.PAYWALL_SCREEN);
                  }
                },
              ),
            );
          },
        ),
        if (!state.showCustomization) const SizedBox(height: 12),
        _buildAnimatedCard(state),
      ],
    );
  }

  Widget _buildAnimatedCard(CardLoaded state) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: _buildLegacyCard(state));
      },
    );
  }

  Widget _buildLegacyCard(CardLoaded state) {
    final gradient =
        state.card.selectedGradientIndex != null && state.card.selectedGradientIndex! < state.gradientOptions.length
            ? state.gradientOptions[state.card.selectedGradientIndex!]
            : state.gradientOptions.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lottie.asset("assets/lottie/gradient_lottie_bg.json"),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(right: 12.width, left: 12.width, top:  state.showCustomization? 3:6.height),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/welcome_card_bg.gif'),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     gradient.colors[0],
            //     gradient.colors.last,
            //   ],
            // ),
            boxShadow: [
              BoxShadow(
                color: gradient.colors[0].withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [_buildCardHeader(state), 22.kh, _buildCardContent(state)]),
        ),
        _buildCardFooter(state),
      ],
    );
  }

  Widget _buildCardHeader(CardLoaded state) {
    return Row(
      children: [
        Text(AppStrings.userArchive.replaceAll("user_name", AppService.userFirstName), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
        const Spacer(),
        AppButton(
          child: SvgPicture.asset(Images.ic_edit_svg, height: 24, width: 24),
          onPressed: () {
            if (!state.showCustomization) {
              _showCustomizationFunction(state);
              context.read<CardCubit>().showCustomization();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCardContent(CardLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.card.subtitle ?? "", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.normal)),
        const SizedBox(height: 4),
        Text("${state.card.wisdomStreak} Days", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardFooter(CardLoaded state) {
    return Container(
      margin: EdgeInsets.only(right: 12.width, left: 12.width, bottom: state.showCustomization ? 4.height : 6.height),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(color: AppColors.brownColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildCardFooterLeft(state), _buildCardFooterRight(state)]),
    );
  }

  Widget _buildCardFooterLeft(CardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Memories captured", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        Text("${state.card.memoriesCaptured}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardFooterRight(CardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Legacy started", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
        Text(state.card.legacyStartDate ?? "", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }



  Widget _buildCustomizationGrid(CardLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: state.gradientOptions.length,
        itemBuilder: (context, index) {
          return _buildGradientOption(state, index);
        },
      ),
    );
  }

  Widget _buildGradientOption(CardLoaded state, int index) {
    bool isSelected = state.card.selectedGradientIndex == index;
    return AnimatedBuilder(
      animation: _gridItemAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _gridItemAnimations[index].value,
          child: GestureDetector(
            onTap: () {
              context.read<CardCubit>().updateGradient(index);
            },
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 10,top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    state.gradientOptions[index].colors[0],
                    state.gradientOptions[index].colors[1],
                    state.gradientOptions[index].colors[2],
                  ],

                ),

                boxShadow: [
                  BoxShadow(
                    color: state.gradientOptions[index].colors[0].withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedContainer(duration: const Duration(milliseconds: 250),height: isSelected?20:0,width: isSelected?20:0,decoration:const BoxDecoration(shape: BoxShape.circle,color: Color(0xFF3054F4)),child:isSelected? const Icon(Icons.check, color: Colors.white, size: 12):null)
              ,
            ),
          ),
        );
      },
    );
  }


  void _showCustomizationFunction(CardLoaded state) {
    print("card Check...${state.showCustomization}");
    _gridItemControllers = List.generate(
      state.gradientOptions.length,
          (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    _gridItemAnimations =
        _gridItemControllers
            .map(
              (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceOut),
          ),
        )
            .toList();
    for (int i = 0; i < _gridItemControllers.length; i++) {
      _gridItemControllers[i].reset();
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) _gridItemControllers[i].forward();
      });
    }
  }

}
