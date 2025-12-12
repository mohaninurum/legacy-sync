import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  EdgeInsets padding;
  Function onPressed;
  Widget child;
  AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding = EdgeInsets.zero,
  });
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
      child: child,
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onPressed();
      },
    );
  }
}
