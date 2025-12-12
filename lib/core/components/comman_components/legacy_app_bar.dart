import 'package:flutter/material.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';

// ignore: must_be_immutable
class LegacyAppBar extends StatelessWidget {
  Function? onBackPressed;
  String? title;
  Widget? actionWidget;
  Color iconColor;
  bool showBackButton;
  LegacyAppBar({super.key, this.onBackPressed, this.title, this.actionWidget,this.iconColor = Colors.white,this.showBackButton = true});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: AppButton(
        padding: const EdgeInsets.only(top: 14),
        onPressed: () {
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.pop(context);
          }
        },
        child: showBackButton? Icon(Icons.arrow_back_ios_rounded, color:iconColor):const SizedBox.shrink(),
      ),
      title: title != null ? Padding(padding: const EdgeInsets.only(top: 14), child: Text(title!, style: Theme.of(context).textTheme.bodyLarge)) : null,
      actions: actionWidget != null ? [actionWidget!] : null,
    );
  }
}
