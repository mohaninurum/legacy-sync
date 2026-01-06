import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/images/images.dart';


class AudioOverlayWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final bool isPlaying;

  const AudioOverlayWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onPlayPause,
    required this.onNext,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white.withOpacity(0.08), // base glass color
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.33), // glossy shine
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                /// Main Content
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        imagePath,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: onPlayPause,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: onNext,
                      icon: SvgPicture.asset(
                        Images.next_play,
                        height: 24,
                        width: 24,
                        colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

