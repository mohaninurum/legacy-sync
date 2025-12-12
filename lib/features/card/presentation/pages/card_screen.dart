import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_bloc/card_cubit.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_state/card_state.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class CardScreen extends StatefulWidget {
  bool hideContinueButton;
   CardScreen({super.key, this.hideContinueButton = false});
  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late List<AnimationController> _gridItemControllers;
  late List<Animation<double>> _gridItemAnimations;

  @override
  void initState() {
    super.initState();
    context.read<CardCubit>().loadCard();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInitialCard();
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    if(_gridItemControllers != null){
      for (var controller in _gridItemControllers) {
        controller.dispose();
      }
    }

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
        top: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: BlocBuilder<CardCubit, CardLoaded>(
              builder: (context, state) {
                return LegacyAppBar(
                  showBackButton: state.showCustomization?true:widget.hideContinueButton?true: false,
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
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(CardLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!state.showCustomization) const SizedBox(height: 12),
                _buildWelcomeTitle(state),
                if (!state.showCustomization) _buildWelcomeDescription(),
                if (state.showCustomization) _buildCustomizationGrid(state),
                _buildBottomNavigationBar(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeTitle(CardLoaded state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          state.showCustomization ? "Customize your card" : "Let's Go!",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (!state.showCustomization)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _buildWelcomeSubtitle(AppService.userName),
          ),
        if (!state.showCustomization) const SizedBox(height: 12),
        _buildAnimatedCard(state),
      ],
    );
  }

  Widget _buildWelcomeSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Welcome $name. Here's your tracked Legacy card",
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWelcomeDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Text(
          "Crafting your legacy your way. Now lets build the app around you.",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(CardLoaded state) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleController.value,
          child: _buildLegacyCard(state),
        );
      },
    );
  }

  Widget _buildLegacyCard(CardLoaded state) {
    // Get current gradient
    final currentGradient =
        state.card.selectedGradientIndex != null &&
                state.card.selectedGradientIndex! < state.gradientOptions.length
            ? state.gradientOptions[state.card.selectedGradientIndex!]
            : state.gradientOptions.first;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use AnimatedSwitcher for smooth fade transition
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Container(
            key: ValueKey(currentGradient.index), // Key for AnimatedSwitcher
            width: double.infinity,
            margin: EdgeInsets.only(
              right: 12.width,
              left: 12.width,
              top: 6.height,
            ),
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
              //   colors: currentGradient.colors,
              // ),
              boxShadow: [
                BoxShadow(
                  color: currentGradient.colors[0].withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCardHeader(state),
                14.kh,
                _buildCardContent(state),
              ],
            ),
          ),
        ),
        _buildCardFooter(state),
      ],
    );
  }

  Widget _buildCardHeader(CardLoaded state) {
    return Row(
      children: [
        Text(
          AppStrings.userArchive.replaceAll("user_name", AppService.userFirstName),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        Text(
          state.card.subtitle ?? "",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${state.card.wisdomStreak} Days",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter(CardLoaded state) {
    return Container(
      margin: EdgeInsets.only(
        right: 12.width,
        left: 12.width,
        bottom: state.showCustomization ? 4.height : 6.height,
      ),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: AppColors.brownColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildCardFooterLeft(state), _buildCardFooterRight(state)],
      ),
    );
  }

  Widget _buildCardFooterLeft(CardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Memories captured",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
        Text(
          "${state.card.memoriesCaptured}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooterRight(CardLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Legacy started",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
        Text(
          state.card.legacyStartDate ?? "",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(CardLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Visibility(
        visible: !widget.hideContinueButton,
        child: CustomButton(
          btnText: "Continue",
          onPressed: () {
            if (state.showCustomization) {
              context.read<CardCubit>().hideCustomization();
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.HOME_SCREEN,
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ),
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
