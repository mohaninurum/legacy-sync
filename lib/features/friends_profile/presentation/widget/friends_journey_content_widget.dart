import 'package:flutter/material.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:legacy_sync/features/home/data/model/pipe_animation_model.dart';
import 'package:legacy_sync/features/home/presentation/widgets/journey_card_widget.dart';
import 'package:legacy_sync/features/home/presentation/widgets/pipe_animation_widget.dart';

class FriendsJourneyContentWidget extends StatelessWidget {
  final List<JourneyCardModel> cards;
  final List<PipeAnimationModel> pipes;
  final Function(int) onCardTapped;
  final List<AnimationController> pipeControllers;
  final List<Animation<double>> pipeAnimations;

  const FriendsJourneyContentWidget({super.key, required this.cards, required this.pipes, required this.onCardTapped, required this.pipeControllers, required this.pipeAnimations});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                child: Padding(padding: EdgeInsets.only(bottom: index == 7 ? 100 : 0), child: JourneyCardWidget(card: cards[index], isLeft: isLeft, onTap: () => onCardTapped(index))),
              ),
            ],
          );
        }),
      ],
    );

  }
}
