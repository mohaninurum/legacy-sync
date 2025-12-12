import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/config/routes/routes.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';
import 'package:legacy_sync/features/home/presentation/widgets/journey_card_widget.dart';
import 'package:legacy_sync/features/home/presentation/widgets/pipe_animation_widget.dart';
import 'package:legacy_sync/services/app_service/app_service.dart';

class JourneyContentWidget extends StatelessWidget {
  final List<JourneyCardModel> cards;
  final List<PipeAnimationModel> pipes;
  final Function(int) onCardTapped;
  final List<AnimationController> pipeControllers;
  final List<Animation<double>> pipeAnimations;

  const JourneyContentWidget({super.key, required this.cards, required this.pipes, required this.onCardTapped, required this.pipeControllers, required this.pipeAnimations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(65), child: _buildHeader(context)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text widgets that scroll with content
            Text('Your Wisdom, Ready To Guide Future Generations', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400, height: 1.2)),
            const SizedBox(height: 12),
            Text("Being crafting your living legacy. Ensure your unique voice lives on", style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
            const SizedBox(height: 20),

            // Journey cards
            ...List.generate(8, (index) {
              final isLeft = index % 2 == 0;
              return Stack(
                children: [
                  // Disabled pipe background (always shown for all pipes)
                  if (index < 7) PipeAnimationWidget(pipe: pipes[index], isLeft: isLeft, cards: cards, animationProgress: 0.0),

                  // Animated pipe filling (shown when animating or enabled)
                  if (index < 7)
                    AnimatedBuilder(
                      animation: pipeAnimations[index],
                      builder: (context, child) {
                        // Use the Flutter animation value for smooth animation
                        final animationValue = pipeAnimations[index].value;
                        return PipeAnimationWidget(pipe: pipes[index], isLeft: isLeft, cards: cards, animationProgress: animationValue);
                      },
                    ),

                  // Container
                  Align(
                    alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                    child: Padding(padding: EdgeInsets.only(bottom: index == 7 ? 100 : 0), child: Hero(
                        tag: cards[index].title,
                        child: JourneyCardWidget(card: cards[index], isLeft: isLeft, onTap: () => onCardTapped(index)))),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFFF69B4), shape: BoxShape.circle), child: Image.asset('assets/images/profile_icon.png')),
          const SizedBox(width: 12),
          Text('Hello, ${AppService.userFirstName}!', style: GoogleFonts.nunito(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.VOICE_GROWING_SCREEN);
                },
                child: Image.asset("assets/images/plant_icon.png", height: 24, width: 24),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                  onTap: () {
                  },
                  child: Image.asset("assets/images/fire_icon.png", height: 24, width: 24)),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.FAVORITE_MEMORIES_SCREEN);
                },
                child: Image.asset(Images.book_mark_ic, height: 24, width: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
