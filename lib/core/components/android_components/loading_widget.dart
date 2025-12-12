import 'package:flutter/material.dart';

import '../comman_components/loading_view.dart';

class LoadingWidget implements LoadingView {
  @override
  Widget build() {
    return const CircularProgressIndicator(color: Colors.redAccent);
  }
}
