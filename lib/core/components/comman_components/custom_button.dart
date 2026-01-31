import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CustomButton extends StatelessWidget {
  double height;
  final bool isLoadingState;
  final Widget leftWidget;
  final Widget rightWidget;
  final bool enable;
  final bool isMoudel;
  final bool isOtherColor;
  final bool bgTransparent;
  final bool isShadows;
  final bool onlyBorder;
  final String btnText;
  final VoidCallback onPressed;
   CustomButton({
    super.key,
    this.rightWidget = const SizedBox.shrink(),
    this.leftWidget = const SizedBox.shrink(),
    this.isLoadingState = false,
    this.enable = true,
    this.isMoudel = false,
    this.isOtherColor = false,
    this.bgTransparent = false,
    this.isShadows = false,
    this.onlyBorder = false,
    this.height = 56,
    required this.onPressed,
    required this.btnText,
  });
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (!isLoadingState) {
          if (enable) {
            onPressed();
          }
        }
      },
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              bgTransparent
                  ? null
                  : RadialGradient(
                    colors: enable
                            ? isOtherColor
                              ? [ const Color(0xFF3ED17A), const Color(0xFF3ED17A).withValues(alpha: 0.8),const Color(0xFF3ED17A).withValues(alpha: 0.8), const Color(0xFF3ED17A),]
                              : isMoudel
                              ?[const Color(0xFF879bf2), const Color(0xFF5b77f0)]
                              :[const Color(0xFF9480fa), const Color(0xFF6447f8)]
                            : [
                              AppColors.grey400, // Gray-400
                              AppColors.grey500, // Gray-500
                            ],
                    center: Alignment.center,
                    radius: 1.0,
                  ),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: onlyBorder ? AppColors.grey : Colors.transparent, width: onlyBorder ? 1 : 0),
          boxShadow:
          // const [
          //   BoxShadow(
          //     color:Color(0xFF10012c),
          //  blurRadius: 15,
          //     offset: Offset(0, 10),
          //     spreadRadius: 2,
          //   ),
          //   BoxShadow(
          //     color:Color(0xFF10012c),
          //     blurRadius: 50,
          //     offset: Offset(0, 20),
          //     spreadRadius: 5,
          //   ),
          // ]
             bgTransparent
                  ? null
                  : isShadows  ? [
          const BoxShadow(
            color:Color(0xFF10012c),
         blurRadius: 15,
            offset: Offset(0, 20),
            spreadRadius: 4,
          ),
          const BoxShadow(
            color:Color(0xFF10012c),
            blurRadius: 50,
            offset: Offset(0, 30),
            spreadRadius: 5,
          ),
        ]
         :[
                    const BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.25), blurRadius: 12, offset: Offset(0, 0), inset: true),
                    const BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.22), blurRadius: 32, offset: Offset(0, -10), inset: true),
                    const BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.26), blurRadius: 24, offset: Offset(0, 8), inset: true),
                  ],
        ),
        child: Center(
          child:
              isLoadingState
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.whiteColor, strokeWidth: 2))
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(padding: const EdgeInsets.only(right: 10), child: leftWidget),
                      Text(btnText, style: const TextStyle(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w600)),
                      Padding(padding: const EdgeInsets.only(left: 10), child: rightWidget),
                    ],
                  ),
        ),
      ),
    );
  }
}
