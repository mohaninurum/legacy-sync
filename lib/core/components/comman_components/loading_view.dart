import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../android_components/loading_widget.dart';
import '../ios_components/ios_loading_widget.dart';

abstract class LoadingView {
  Widget build();
  factory LoadingView() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return LoadingWidget();
      case TargetPlatform.iOS:
        return IosLoadingWidget();
      default:
        return LoadingWidget();
    }
  }
}
