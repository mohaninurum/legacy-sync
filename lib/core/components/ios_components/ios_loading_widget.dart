import 'package:flutter/cupertino.dart';

import '../comman_components/loading_view.dart';

class IosLoadingWidget implements LoadingView {
  @override
  Widget build() {
    return const CupertinoActivityIndicator();
  }
}
