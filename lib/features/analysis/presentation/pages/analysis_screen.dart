import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_cubit.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_state/analysis_state.dart';
import 'package:vibration/vibration.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _textController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Start analysis after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AnalysisCubit>().initializeAnalysis();
        context.read<AnalysisCubit>().startAnalysis();
        _startAnimations();
      }
    });
  }

  void _initializeAnimations() {
    // Initialize animation controllers
    _progressController = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);

    _textController = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);

    // Setup progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInQuad));//easeInQuad//easeInCubic

    // Listen to progress animation
    _progressAnimation.addListener(() {
      final cubit = context.read<AnalysisCubit>();
      final currentPercentage = _progressAnimation.value * cubit.state.targetPercentage;
      cubit.updateProgress(currentPercentage);
    });
    // Listen to text animation completion
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Vibration.cancel();
        context.read<AnalysisCubit>().completeAnalysis();

        // Navigate to analysis complete screen after 1 second delay
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            Navigator.pushNamed(context, RoutesName.ANALYSIS_COMPLETE_SCREEN);
          }
        });
      }
    });
  }

  void _startAnimations() {
    _progressController.forward();
    _textController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _textController.dispose();
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
          body: _buildBody(),
        ),
      ),
    );
  }



  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildCircularProgressIndicator(), const SizedBox(height: 50), _buildCalculatingText(), const SizedBox(height: 16), _buildSubText()],
      ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return BlocBuilder<AnalysisCubit, AnalysisState>(
      builder: (context, state) {
        return SizedBox(
          width: 50.width,
          height: 25.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(width: 50.width, height: 50.width, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColorDull.withValues(alpha: 0.3))),
              // Progress circle
              SizedBox(
                width: 50.width,
                height: 50.width,
                child: CircularProgressIndicator(
                  value: state.currentPercentage / 100,
                  strokeWidth: 20,
                  backgroundColor: AppColors.primaryColorDull,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Percentage text
              Text("${state.currentPercentage.toInt()}%", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.whiteColor)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalculatingText() {
    return Text(AppStrings.calculating, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.whiteColor));
  }

  Widget _buildSubText() {
    return Text(AppStrings.buildingCustomPlan, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.whiteColor));
  }
}
