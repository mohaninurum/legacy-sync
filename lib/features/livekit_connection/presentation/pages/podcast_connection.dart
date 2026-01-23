// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
// import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_state.dart';
// import 'room.dart';
//
// class PodcastConnection extends StatelessWidget {
//   final String roomId;
//   final bool incomingCall;
//   final String userName;
//   final int userId;
//
//   const PodcastConnection({super.key, required this.roomId, required this.incomingCall, required this.userName, required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     if (roomId.isEmpty) {
//       return const Scaffold(body: Center(child: Text("Room id missing")));
//     }
//
//     return BlocProvider(
//       create: (_) => LiveKitConnectionCubit()..connect(roomId: roomId, userName: userName, userId: userId),
//       child: BlocBuilder<LiveKitConnectionCubit, LiveKitConnectionState>(
//         builder: (context, state) {
//           return switch (state.status) {
//             LiveKitStatus.connecting => Scaffold(
//               appBar: AppBar(title: const Text("Connecting...")),
//               body: Center(child: Text(state.message ?? "Please wait...")),
//             ),
//             LiveKitStatus.failure => Scaffold(
//               appBar: AppBar(title: const Text("Connection failed")),
//               body: Center(child: Text(state.message ?? "Unknown error")),
//             ),
//             LiveKitStatus.connected => RoomPage(state.room!, state.listener!,userName: userName, incomingCall: incomingCall),
//             _ => const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             ),
//           };
//         },
//       ),
//     );
//   }
// }
