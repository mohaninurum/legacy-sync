import 'package:flutter/cupertino.dart';
import 'package:legacy_sync/core/colors/colors.dart';

// ignore: must_be_immutable
class SocialButton extends StatelessWidget {
  Widget icon;
  Function ontap;

  SocialButton({super.key, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      onPressed: () {
        ontap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.greyBlue, width: 2),
        ),
        child: icon,
      ),
    );
  }
}
