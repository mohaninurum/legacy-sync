import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';

import '../../../../../core/images/images.dart';

class MicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final isRounded;
  final icon;
  final label;
  final isRedColor;
  final isSVG;
  const MicButton({super.key,required this.onPressed,this.isRounded=false,this.icon,this.label,this.isRedColor,this.isSVG=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width:  isRounded?75:95,
            height: isRounded?75:50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isRounded?50:40),
              /// 🔴 RED GRADIENT
              gradient:  LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isRedColor?const [
                  AppColors.redColor,
                  AppColors.redColor,

                ]:const [
                  AppColors.primaryColorDark,
                  AppColors.primaryColorDark,
                ],
              ),

              /// 🌟 SHADOWS (OUTER + INNER)
              boxShadow:  [

                /// INNER WHITE SHADOW
                BoxShadow(
                  color: const Color.fromRGBO(255, 255, 255, 0.30),
                  blurRadius:  isRedColor?15: 20,
                  offset: const Offset(0, -4),
                  inset: true,
                ),

                BoxShadow(
                  color: const Color.fromRGBO(255, 255, 255, 0.22),
                  blurRadius:isRedColor?28: 15,
                  offset: const Offset(0, 6),
                  inset: true,
                ),
              ],
            ),
            child: Center(
              child: isSVG?SvgPicture.asset(icon,height: 26,width: 26,): Image.asset(
              icon,
                height: 26,
                width: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),),
      ],
    );
  }
}
