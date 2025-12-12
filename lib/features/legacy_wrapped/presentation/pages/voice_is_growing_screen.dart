import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import '../../../../core/components/comman_components/legacy_app_bar.dart';
import '../../../../core/images/images.dart';

class VoiceIsGrowingScreen extends StatefulWidget {
  const VoiceIsGrowingScreen({super.key});

  @override
  State<VoiceIsGrowingScreen> createState() => _VoiceIsGrowingScreenState();
}

class _VoiceIsGrowingScreenState extends State<VoiceIsGrowingScreen> {
  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.img_voice_is_growing,
      child: SafeArea(

        child: Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
          backgroundColor: Colors.transparent,
          body: const SizedBox(),
          bottomNavigationBar: _buildGlassyBottomBar(context),
        ),
      ),
    );
  }
  Widget _buildAppBar() {
    return LegacyAppBar(iconColor: Colors.black);
  }
  Widget _buildGlassyBottomBar(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(right: 16,left: 16,top: 16,bottom: 6.5.height), // Outer margin of 16
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16), // Inner padding of 16
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withValues(alpha:  0.15),
              borderRadius: BorderRadius.circular(10),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade900.withValues(alpha: 0.25),
                  Colors.grey.shade900.withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Voice is Growing',
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).bodyLarge!.copyWith(

                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '4 Days Longest Streaks!',
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).bodyMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                // Subtitle with streak info

                const SizedBox(height: 20),

                // Description text
                Text(
                  'You\'re growing something meaningful — a voice that will always be there when they need it.',
                  textAlign: TextAlign.center,
                  style: TextTheme.of(context).bodyMedium!.copyWith(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}