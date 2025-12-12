import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/home/data/model/journey_card_model.dart';
import 'package:lottie/lottie.dart';

class JourneyCardWidget extends StatelessWidget {
  final JourneyCardModel card;
  final bool isLeft;
  final VoidCallback onTap;

  const JourneyCardWidget({
    super.key,
    required this.card,
    required this.isLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorFromHex(card.colorCode);
    final opacity = card.isEnabled ? 1.0 : 0.4;

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Column(
              children: [
                Container(
                  width: 126,
                  height: 105,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: card.isEnabled ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Lottie.asset(card.imagePath),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 126,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      card.title,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          card.isEnabled?const SizedBox.shrink(): Positioned(
              right: 10,

              top: 10,
              child: Image.asset(Images.ic_lock,height: 24,width: 24))
        ],
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    // Remove any existing prefixes and ensure we have a clean hex string
    String cleanHex = hexColor.replaceAll('#', '').replaceAll('0x', '');
    
    // If the hex string doesn't start with FF, add it for alpha
    if (!cleanHex.startsWith('FF')) {
      cleanHex = 'FF$cleanHex';
    }
    
    return Color(int.parse(cleanHex, radix: 16));
  }
}
