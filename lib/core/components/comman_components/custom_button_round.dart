import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CustomButtonRound extends StatelessWidget {
  final bool isLoadingState;
  final bool enable;
  final Widget child;
  final VoidCallback onPressed;
  const CustomButtonRound({super.key, this.isLoadingState = false, this.enable = true, required this.onPressed, required this.child});
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
        if (!isLoadingState) {

            onPressed();

        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors:
                enable
                    ? [const Color(0xFF6447f8), const Color(0xFF9480fa)]
                    : [
                      AppColors.grey500, // Gray-500

                      AppColors.grey400, // Gray-400
                    ],
            center: Alignment.center,
            radius: 1.0,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.25), blurRadius: 12, offset: Offset(0, 0), inset: true),
            BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.22), blurRadius: 32, offset: Offset(0, -10), inset: true),
            BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.26), blurRadius: 24, offset: Offset(0, 8), inset: true),
          ],
        ),
        child: Center(child: isLoadingState ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2)) : child),
      ),
    );
  }
}
