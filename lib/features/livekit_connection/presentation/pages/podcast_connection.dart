
import 'package:flutter/material.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/pages/connect.dart';
class PodcastConnection extends StatefulWidget {
  const PodcastConnection({super.key});

  @override
  State<PodcastConnection> createState() => _PodcastConnectionState();
}

class _PodcastConnectionState extends State<PodcastConnection> {
  @override
  Widget build(BuildContext context) {
    return const ConnectPage();
  }
}
