import 'package:flutter/material.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/utils/theme.dart';
import 'dart:math' as math;

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (ctx, constraints) => Icon(
            Icons.videocam_off_outlined,
            color: LKColors.lkBlue,
            size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
          ),
        ),
      );
}
