
import 'package:flutter/material.dart';
import 'package:legacy_sync/features/audio_overlay_manager/widgets/audio_overlay_widget.dart';

class AudioOverlayManager {
  static OverlayEntry? _entry;
  static final ValueNotifier<bool> isPlayingNotifier =
  ValueNotifier(false);

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onPlayPause,
    required VoidCallback onNext,
  }) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 16,
        right: 16,
        bottom: 24,
        child: ValueListenableBuilder<bool>(
          valueListenable: isPlayingNotifier,
          builder: (_, isPlaying, __) {
            return AudioOverlayWidget(
              title: title,
              subtitle: subtitle,
              imagePath: imagePath,
              isPlaying: isPlaying,
              onPlayPause: onPlayPause,
              onNext: onNext,
            );
          },
        ),
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  static void updatePlaying(bool value) {
    isPlayingNotifier.value = value;
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
