import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/analysis/presentation/bloc/analysis_cubit/analysis_complete_cubit.dart';

class AnalysisCompleteScreen extends StatefulWidget {
  const AnalysisCompleteScreen({super.key});

  @override
  State<AnalysisCompleteScreen> createState() => _AnalysisCompleteScreenState();
}

class _AnalysisCompleteScreenState extends State<AnalysisCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _pieChartController;
  late Animation<double> _pieChartAnimation;
  int? _randomIndex;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    context.read<AnalysisCompleteCubit>().startAnimation();
    _generateRandomData();
  }

  void _initializeAnimations() {
    _pieChartController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _pieChartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pieChartController, curve: Curves.easeInOut),
    );
  }

  void _generateRandomData() {
    setState(() {
      _randomIndex = Random().nextInt(3);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pieChartController.forward();
        }
      });
    });


  }

  @override
  void dispose() {
    _pieChartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildAppBar(),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 8.height),
          buildRandomPieChart(),
          SizedBox(height: 4.height),
          _buildFocusAreasText(),
          SizedBox(height: 4.height),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.analysisComplete,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(Images.ic_verify_svg),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.personalizedSpaceMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  // Widget _buildPieChart() {
  //   final dataMap = <String, double>{AppStrings.childhood: 40, AppStrings.familyValues: 35, AppStrings.lifeLessons: 25};
  //   final dataMap1 = <String, double>{AppStrings.career: 25,AppStrings.childhood: 25, AppStrings.familyValues: 25, AppStrings.lifeLessons: 25};
  //   final dataMap2 = <String, double>{AppStrings.childhood: 40, AppStrings.familyValues: 35, AppStrings.lifeLessons: 25};
  //   final colorList = <Color>[AppColors.holoPink, AppColors.yellowfad, AppColors.skyblue];
  //   final colorList1 = <Color>[AppColors.bricColor,AppColors.holoPink, AppColors.yellowfad, AppColors.skyblue];
  //   final colorList2 = <Color>[AppColors.skyblueLight,AppColors.bricColor,AppColors.holoPink, AppColors.yellowfad, AppColors.skyblue];
  //
  //   final data = dataMap1;
  //   List<PieChartSectionData> getSections() {
  //     return data.entries.map((entry) {
  //       final index = data.keys.toList().indexOf(entry.key);
  //       return PieChartSectionData(
  //         value: entry.value,
  //         title: entry.key,
  //         color: colorList[index],
  //         radius: 35.width,
  //         titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
  //       );
  //     }).toList();
  //   }
  //
  //   return SizedBox(
  //     height: 30.height,
  //     width: 50.width,
  //     child: PieChart(
  //       PieChartData(
  //         sections: getSections(),
  //         startDegreeOffset: -90,
  //         sectionsSpace: 0,
  //         centerSpaceRadius: 0,
  //         // Adjust to match your design
  //         borderData: FlBorderData(show: true),
  //       ),
  //       swapAnimationDuration: const Duration(milliseconds: 1200),
  //     ),
  //   );
  // }

  Widget buildRandomPieChart() {
    // Return loading indicator if random data hasn't been generated yet
    if (_randomIndex == null) {
      return SizedBox(
        height: 30.height,
        width: 50.width,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.whiteColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // Your 3 data maps
    final List<Map<String, double>> dataMaps = [
      {
        AppStrings.childhood: 40,
        AppStrings.familyValues: 35,
        AppStrings.lifeLessons: 25,
      },
      {
        AppStrings.career: 25,
        AppStrings.childhood: 25,
        AppStrings.familyValues: 25,
        AppStrings.lifeLessons: 25,
      },
      {
        AppStrings.childhood: 40,
        AppStrings.familyValues: 35,
        AppStrings.lifeLessons: 25,
      },
    ];

    // Your 3 color lists
    final List<List<Color>> colorLists = [
      [AppColors.holoPink, AppColors.yellowfad, AppColors.skyblue],
      [
        AppColors.bricColor,
        AppColors.holoPink,
        AppColors.yellowfad,
        AppColors.skyblue,
      ],
      [
        AppColors.skyblueLight,
        AppColors.bricColor,
        AppColors.holoPink,
        AppColors.yellowfad,
        AppColors.skyblue,
      ],
    ];

    // Use the stored random index
    final data = dataMaps[_randomIndex!];
    final colorList = colorLists[_randomIndex!];

    List<PieChartSectionData> getSections() {
      return data.entries.map((entry) {
        final index = data.keys.toList().indexOf(entry.key);
        // Calculate the animated value for this section
        final totalValue = data.values.fold(0.0, (sum, value) => sum + value);
        final sectionProgress = _pieChartAnimation.value;

        // Calculate when this section should start appearing
        final previousSectionsValue = data.entries
            .take(index)
            .fold(0.0, (sum, entry) => sum + entry.value);
        final sectionStartProgress = previousSectionsValue / totalValue;

        // Calculate the animated value for this specific section
        final sectionValue = entry.value * sectionProgress;
        final isSectionVisible = sectionProgress >= sectionStartProgress;

        return PieChartSectionData(
          value: isSectionVisible ? sectionValue : 0.0,
          title: isSectionVisible ? entry.key : '',
          color: colorList[index % colorList.length],
          radius: 35.width,
          titleStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        );
      }).toList();
    }

    return AnimatedBuilder(
      animation: _pieChartAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 30.height,
          width: 50.width,
          child: PieChart(
            PieChartData(
              sections: getSections(),
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              borderData: FlBorderData(show: true),
            ),
            swapAnimationDuration: const Duration(milliseconds: 300),
          ),
        );
      },
    );
  }

  Widget _buildFocusAreasText() {
    return Text(
      AppStrings.yourFocusAreas,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          AppStrings.readyToBuildConnection,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
        ),
        SizedBox(height: 4.height),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildContinueButton() {
    return CustomButton(
      onPressed: () {
        Navigator.pushNamed(context, RoutesName.ONBOARDING_SCREEN);
      },
      btnText: AppStrings.continueText,
      enable: true,
      isLoadingState: false,
    );
  }
}
