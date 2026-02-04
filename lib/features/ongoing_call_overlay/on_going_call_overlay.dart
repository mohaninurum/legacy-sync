import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_state.dart';

class OngoingCallOverlay extends StatefulWidget {
  const OngoingCallOverlay({super.key});

  @override
  State<OngoingCallOverlay> createState() => _OngoingCallOverlayState();
}

class _OngoingCallOverlayState extends State<OngoingCallOverlay> {
  Offset _pos = const Offset(16, 120);
  bool _initialized = false;

  // overlay size (approx). used for clamping.
  static const Size _cardSize = Size(360, 50);

  Offset _clampToScreen(BuildContext context, Offset p) {
    final mq = MediaQuery.of(context);
    final padding = mq.padding; // safe area

    final w = mq.size.width;
    final h = mq.size.height;

    // leave small margin
    const m = 12.0;

    final minX = m;
    final maxX = w - _cardSize.width - m;

    final minY = padding.top + m;
    final maxY = h - padding.bottom - _cardSize.height - m;

    return Offset(
      p.dx.clamp(minX, math.max(minX, maxX)),
      p.dy.clamp(minY, math.max(minY, maxY)),
    );
  }

  Offset _snapToEdge(BuildContext context, Offset p) {
    final w = MediaQuery.of(context).size.width;
    const m = 12.0;

    final left = m;
    final right = w - _cardSize.width - m;

    // snap based on which side is nearer
    final snapX = (p.dx + _cardSize.width / 2) < (w / 2) ? left : right;
    return Offset(snapX, p.dy);
  }

  void _ensureInitialPos(BuildContext context) {
    if (_initialized) return;
    _initialized = true;

    // Place near bottom by default (feels natural)
    final mq = MediaQuery.of(context);
    final p = Offset(16, mq.size.height * 0.70);
    _pos = _clampToScreen(context, p);
  }

  @override
  Widget build(BuildContext context) {
    _ensureInitialPos(context);

    return BlocBuilder<LiveKitConnectionCubit, LiveKitConnectionState>(
      buildWhen:
          (p, c) =>
              p.callStatus != c.callStatus ||
              p.showCallOverlay != c.showCallOverlay ||
              p.participants != c.participants ||
              p.roomId != c.roomId ||
              p.isMic != c.isMic ||
              p.isSpeaker != c.isSpeaker,
      builder: (context, state) {
        final visible =
            state.callStatus == CallStatus.connected && state.showCallOverlay;

        if (!visible) return const SizedBox.shrink();

        final other = state.participants.firstWhere(
          (p) => p.userIdPK != state.myUserId,
          orElse: () => FriendsDataList(firstName: ""),
        );

        return Positioned(
          left: _pos.dx,
          top: _pos.dy,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (_) {},
            onPanUpdate: (d) {
              setState(() {
                _pos = _clampToScreen(context, _pos + d.delta);
              });
            },
            onPanEnd: (_) {
              setState(() {
                _pos = _snapToEdge(context, _pos);
              });
            },
            child: _OverlayCard(
              name: other.firstName ?? '',
              onTap: () {
                context.read<LiveKitConnectionCubit>().hideOverlay();
                Utils.navigatorKey.currentState?.pushNamed(
                  RoutesName.ROOM_PAGE,
                  arguments: {
                    "roomId": state.roomId ?? "",
                    "incoming_call": !state.isHost,
                    "userName": state.myUserName ?? "",
                    "userId": state.myUserId ?? -1,
                  },
                );
              },
              state: state,
              onEnd: () async {
                await context.read<LiveKitConnectionCubit>().endCall();
              },
            ),
          ),
        );
      },
    );
  }
}

class _OverlayCard extends StatefulWidget {
  final String name;
  final VoidCallback onTap;
  final VoidCallback onEnd;
  final LiveKitConnectionState state;

  const _OverlayCard({
    required this.name,
    required this.onTap,
    required this.onEnd,
    required this.state,
  });

  @override
  State<_OverlayCard> createState() => _OverlayCardState();
}

class _OverlayCardState extends State<_OverlayCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onTap,
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1C1F2A).withOpacity(0.98),
                const Color(0xFF121421).withOpacity(0.98),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Container(
              //   height: 44,
              //   width: 44,
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.10),
              //     borderRadius: BorderRadius.circular(14),
              //   ),
              //   child: const Icon(Icons.call, color: Colors.white),
              // ),
              _avatarBubble(name: widget.name),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ongoing call",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.name.isEmpty ? "Connecting..." : widget.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Controls
              _miniBtn(
                icon: (widget.state.isMic == true) ? Icons.mic : Icons.mic_off,
                onTap: () => context.read<LiveKitConnectionCubit>().micONOff(),
              ),
              const SizedBox(width: 6),
              _miniBtn(
                icon:
                    (widget.state.isSpeaker == true)
                        ? Icons.volume_up
                        : Icons.volume_off,
                onTap:
                    () => context.read<LiveKitConnectionCubit>().speakerONOff(),
              ),
              const SizedBox(width: 6),
              _endBtn(
                onTap: () async {
                  await context.read<LiveKitConnectionCubit>().endCall();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarBubble({required String name}) {
    final initials =
        (name.trim().isEmpty)
            ? "?"
            : name
                .trim()
                .split(RegExp(r'\s+'))
                .first
                .characters
                .first
                .toUpperCase();

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _miniBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _endBtn({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.call_end, color: Colors.white, size: 20),
      ),
    );
  }
}
