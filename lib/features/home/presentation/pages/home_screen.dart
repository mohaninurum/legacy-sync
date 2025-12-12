import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/locked_question_dialog.dart';
import 'package:legacy_sync/core/components/comman_components/night_sky_background.dart';
import 'package:legacy_sync/core/components/comman_components/will_pop_scope.dart';
import 'package:legacy_sync/features/home/data/model/navigation_tab_model.dart';
import 'package:legacy_sync/features/home/domain/usecases/navigate_to_module_usecase.dart';
import 'package:legacy_sync/features/home/presentation/bloc/home_bloc/home_cubit.dart';
import 'package:legacy_sync/features/home/presentation/bloc/home_state/home_state.dart';
import 'package:legacy_sync/features/home/presentation/pages/tripe_page_widget.dart';
import 'package:legacy_sync/features/home/presentation/widgets/bottom_navigation_widget.dart';
import 'package:legacy_sync/features/home/presentation/widgets/coming_soon_widget.dart';
import 'package:legacy_sync/features/home/presentation/pages/journey_content_widget.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:legacy_sync/features/profile/presentation/pages/profile_page.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../core/images/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _mainController;
  late Animation<double> _mainAnimation;

  // Animation controllers for pipe flow
  late List<AnimationController> _pipeControllers;
  late List<Animation<double>> _pipeAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    context.read<HomeCubit>().initializeHome(context);
    context.read<HomeCubit>().getFriendsList();
    context.read<ProfileCubit>().loadProfile(context);
    context.read<ProfileCubit>().getLegacySteps();

  }

  void _setupAnimations() {
    _mainController = AnimationController(duration: const Duration(milliseconds: 2200), vsync: this);

    _mainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

    _mainController.repeat(reverse: true); // twinkle driver

    // Setup pipe animation controllers
    _pipeControllers = List.generate(7, (index) {
      return AnimationController(duration: const Duration(milliseconds: 2200), vsync: this);
    });

    _pipeAnimations =
        _pipeControllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
        }).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mainController.dispose();
    for (var controller in _pipeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCardTapped(int index) async {
    final cubit = context.read<HomeCubit>();
    final state = cubit.state;
    if (state.journeyCards[index].isEnabled) {
      final card = state.journeyCards[index];
      final navigationArgs = NavigateToModuleUsecase.execute(card);
      final result = await Navigator.pushNamed(context, RoutesName.LIST_OF_MODULE, arguments: navigationArgs);
      if (result == true) {
        await context.read<HomeCubit>().startJourneyAnimation(index);
      }
    } else {
      LockedQuestionDialog.show(context, title: "module");
    }
  }

  Widget _buildCurrentContent(HomeState state) {
    switch (state.selectedTab) {
      case NavigationTab.journey:
        return JourneyContentWidget(cards: state.journeyCards,
            pipes: state.pipeAnimations,
            onCardTapped: _onCardTapped,
            pipeControllers: _pipeControllers,
            pipeAnimations: _pipeAnimations);
      case NavigationTab.chat:
        return _buildChatContent();
      case NavigationTab.tribe:
        return const TripePageWidget();
      case NavigationTab.profile:
        return const ProfilePage();
    }
  }

  Widget _buildChatContent() {
    return const ComingSoonWidget(
      title: 'Chat & Connect',
      description: 'Engage in meaningful conversations and connect with your community. Share your wisdom and learn from others on their legacy journey.',
      iconPath: 'assets/icons/comment.svg',
      accentColor: Color(0xFF4CAF50), // Green
    );
  }

  Widget _buildTribeContent() {
    return const ComingSoonWidget(
      title: 'Your Tribe',
      description: 'Build and nurture your family connections. Create a space where your loved ones can access your wisdom and continue your legacy.',
      iconPath: 'assets/icons/family-dress.svg',
      accentColor: Color(0xFF9C27B0), // Purple
    );
  }

  Widget _buildProfileContent() {
    return const ComingSoonWidget(
      title: 'Your Profile',
      description: 'Personalize your legacy journey. Manage your settings, view your progress, and customize your experience to reflect your unique story.',
      iconPath: 'assets/icons/user.svg',
      accentColor: Color(0xFF2196F3), // Blue
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // Listen for animation state changes and trigger Flutter animations
        for (int i = 0; i < state.pipeAnimations.length; i++) {
          final pipe = state.pipeAnimations[i];
          if (pipe.isAnimating && !_pipeControllers[i].isAnimating) {
            _pipeControllers[i].forward();
          } else if (!pipe.isAnimating && _pipeControllers[i].isAnimating) {
            _pipeControllers[i].stop();
          }
        }
      },
      builder: (context, state) {
        return AppWillPopScope(
          onExit: (v) {
            exit(0);
          },
          child: SafeArea(
            top: false,
            child: BgImageStack(
              imagePath: Images.splash_bg_image,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    const NightSkyBackground(),
                    // Starry background (twinkle with main animation)
                    // CustomPaint(size: Size.infinite, painter: _StarryBackgroundPainter(t: _mainAnimation.value)),

                    state.isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white)) : _buildCurrentContent(state),
                  ],
                ),
                floatingActionButton: state.isJourneyTab ? _buildContinueButton() : null,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButtonAnimator: NoScalingAnimation(),
                bottomNavigationBar: BottomNavigationWidget(
                  selectedTab: state.selectedTab,
                  onTabChanged: (index) {
                    context.read<HomeCubit>().onNavigationTabChanged(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AppButton(
          onPressed: () {
            context.read<HomeCubit>().onContinueLegacyPressed(context);
          },
          child: Image.asset(!state.isFirstVisit?Images.btn_start_your_legacy:Images.bt_continue_your_legacy, height: 70, width: 250),
        );
      },
    );
  }
}


class DisabledPipePainter extends CustomPainter {
  final bool isLeft;
  final double boxWidth;
  final double boxHeight;
  final double horizontalMargin;
  final double verticalSpacing;
  final double turnFactor;
  final double maxLift;
  final double strokeWidth;
  final List<Color> gradientColors;

  DisabledPipePainter({
    required this.isLeft,
    required this.boxWidth,
    required this.boxHeight,
    required this.horizontalMargin,
    required this.verticalSpacing,
    this.turnFactor = 0.5,
    this.maxLift = 120,
    this.strokeWidth = 6,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(isLeft ? boxWidth + horizontalMargin : size.width - boxWidth - horizontalMargin, boxHeight / 2 + verticalSpacing / 2);

    final p3 = Offset(isLeft ? size.width - boxWidth / 2 - horizontalMargin : boxWidth / 2 + horizontalMargin, boxHeight / 2 + verticalSpacing * 1.5);

    final c1x = (p1.dx + p3.dx) / 2;
    final c2y = p3.dy - (turnFactor * maxLift);

    final path =
    Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(c1x, p1.dy, p3.dx, c2y, p3.dx, p3.dy);

    // Draw disabled pipe with low opacity
    final paint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = gradientColors[0].withValues(alpha: 0.2); // Low opacity for disabled state

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DisabledPipePainter oldDelegate) {
    return oldDelegate.turnFactor != turnFactor || oldDelegate.maxLift != maxLift || oldDelegate.strokeWidth != strokeWidth || oldDelegate.gradientColors != gradientColors;
  }
}

class AnimatedConnectorPainter extends CustomPainter {
  final bool isLeft;
  final double boxWidth;
  final double boxHeight;
  final double horizontalMargin;
  final double verticalSpacing;
  final double turnFactor;
  final double maxLift;
  final double strokeWidth;
  final List<Color> gradientColors;
  final bool isEnabled;
  final double animationProgress;

  AnimatedConnectorPainter({
    required this.isLeft,
    required this.boxWidth,
    required this.boxHeight,
    required this.horizontalMargin,
    required this.verticalSpacing,
    this.turnFactor = 0.5,
    this.maxLift = 120,
    this.strokeWidth = 6,
    this.gradientColors = const [Colors.blue, Colors.purple],
    required this.isEnabled,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(isLeft ? boxWidth + horizontalMargin : size.width - boxWidth - horizontalMargin, boxHeight / 2 + verticalSpacing / 2);

    final p3 = Offset(isLeft ? size.width - boxWidth / 2 - horizontalMargin : boxWidth / 2 + horizontalMargin, boxHeight / 2 + verticalSpacing * 1.5);

    final c1x = (p1.dx + p3.dx) / 2;
    final c2y = p3.dy - (turnFactor * maxLift);

    final path =
    Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(c1x, p1.dy, p3.dx, c2y, p3.dx, p3.dy);

    // Calculate the animated end point based on progress
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final totalLength = pathMetric.length;
    final animatedLength = totalLength * animationProgress;

    // Create animated path
    final animatedPath = Path();
    final extractPath = pathMetric.extractPath(0, animatedLength);
    animatedPath.addPath(extractPath, Offset.zero);

    // Draw the animated path with full opacity
    final paint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = gradientColors[0];

    canvas.drawPath(animatedPath, paint);

    // Draw gradient effect for the flowing liquid
    if (animationProgress > 0) {
      // For right-to-left pipes, reverse the gradient direction
      final gradientColors = isLeft ? this.gradientColors : this.gradientColors.reversed.toList();

      final gradientPaint =
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = LinearGradient(colors: gradientColors).createShader(Rect.fromPoints(p1, p3));

      canvas.drawPath(animatedPath, gradientPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AnimatedConnectorPainter oldDelegate) {
    return oldDelegate.turnFactor != turnFactor ||
        oldDelegate.maxLift != maxLift ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.isEnabled != isEnabled ||
        oldDelegate.animationProgress != animationProgress;
  }
}

class ConnectorPainter extends CustomPainter {
  final bool isLeft;
  final double boxWidth;
  final double boxHeight;
  final double horizontalMargin;
  final double verticalSpacing;
  final double turnFactor; // Controls curve bending
  final double maxLift; // Maximum lift distance
  final double strokeWidth; // Line thickness
  final List<Color> gradientColors; // Gradient colors

  ConnectorPainter({
    required this.isLeft,
    required this.boxWidth,
    required this.boxHeight,
    required this.horizontalMargin,
    required this.verticalSpacing,
    this.turnFactor = 0.5,
    this.maxLift = 120,
    this.strokeWidth = 6,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(isLeft ? boxWidth + horizontalMargin : size.width - boxWidth - horizontalMargin, boxHeight / 2 + verticalSpacing / 2);

    final p3 = Offset(isLeft ? size.width - boxWidth / 2 - horizontalMargin : boxWidth / 2 + horizontalMargin, boxHeight / 2 + verticalSpacing * 1.5);

    final c1x = (p1.dx + p3.dx) / 2;
    final c2y = p3.dy - (turnFactor * maxLift);

    final path =
    Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(c1x, p1.dy, p3.dx, c2y, p3.dx, p3.dy);

    final paint =
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(colors: gradientColors).createShader(Rect.fromPoints(p1, p3));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConnectorPainter oldDelegate) {
    return oldDelegate.turnFactor != turnFactor || oldDelegate.maxLift != maxLift || oldDelegate.strokeWidth != strokeWidth || oldDelegate.gradientColors != gradientColors;
  }
}

class NoScalingAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({required Offset begin, required Offset end, required double progress}) {
    return end; // instantly jump to end
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return kAlwaysCompleteAnimation; // always fully visible
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return kAlwaysDismissedAnimation; // no rotation/flip
  }
}
