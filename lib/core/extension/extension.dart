import 'package:flutter/cupertino.dart';

import '../app_sizes/app_sizes.dart';

extension SizeExtension on num {
  /// Returns a SizedBox with height relative to the screen height
  SizedBox get kh => SizedBox(height: (this / 100) * AppSizes.screenHeight);

  /// Returns a SizedBox with width relative to the screen width
  SizedBox get kw => SizedBox(width: (this / 100) * AppSizes.screenWidth);

  /// Returns a height with height relative to the screen height
  double get height => (this / 100) * AppSizes.screenHeight;

  /// Returns a width with width relative to the screen width
  double get width => (this / 100) * AppSizes.screenWidth;
}

extension EmailExtensions on String {
  bool get isEmail {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(trim());
  }
}

extension MobileExtensions on String {
  bool get isMobile {
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    return mobileRegex.hasMatch(trim());
  }
}
