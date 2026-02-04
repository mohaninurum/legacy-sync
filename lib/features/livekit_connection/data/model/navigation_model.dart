// class LiveKitNavEvent {
//   final String screenName;
//   final Map<String, dynamic>? arguments;
//
//   const LiveKitNavEvent(this.screenName, {this.arguments});
// }


import 'package:equatable/equatable.dart';

class LiveKitNavEvent extends Equatable {
  final String route;
  final Map<String, dynamic>? arguments;

  const LiveKitNavEvent(this.route, {this.arguments});

  static const none = LiveKitNavEvent('_none');

  bool get isNone => route == '_none';

  @override
  List<Object?> get props => [route, arguments];
}
