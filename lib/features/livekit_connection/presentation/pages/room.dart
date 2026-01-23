import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_common_mask_widgets.dart';
import 'package:legacy_sync/core/components/comman_components/podcast_bg.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart' show Utils;
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/home/presentation/bloc/home_state/home_state.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_cubit.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/bloc/livekit_connection_state.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/utils/exts.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/utils/utils.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/audio_waves_desing.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/audio_waves_widget.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/widgets/record_button.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../home/presentation/bloc/home_bloc/home_cubit.dart';
import '../widgets/controls.dart';
import '../widgets/participant.dart';

class RoomPage extends StatefulWidget {
  final String roomId;
  final bool incomingCall;
  final String userName;
  final int userId;

  const RoomPage({
    super.key,
    required this.roomId,
    required this.incomingCall,
    required this.userName,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late final LiveKitConnectionCubit _lkCubit;
  late final HomeCubit _homeCubit;
  @override
  void initState() {
    super.initState();

    _lkCubit = context.read<LiveKitConnectionCubit>();
    _homeCubit = context.read<HomeCubit>();

    _lkCubit.getInviteUse();
    _lkCubit.fetchPodcastTopics();
    // lk.addSelfParticipant(widget.incomingCall);
    _homeCubit.getFriendsList();
    _lkCubit.setHost(!widget.incomingCall);
    _lkCubit.connect(
      roomId: widget.roomId,
      userName: widget.userName,
      userId: widget.userId,
    );

    if (widget.incomingCall) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        showConsentDialog(context);
      });
    }

    if (lkPlatformIsDesktop()) {
      onWindowShouldClose = () async {
        await context.read<LiveKitConnectionCubit>().handleWindowShouldClose();
      };
    }
  }

  @override
  void dispose() {
    onWindowShouldClose = null;
    _lkCubit.disconnect();
    super.dispose();
    // always dispose listener
    // widget.room.removeListener(_onRoomDidUpdate);
    // unawaited(_disposeRoomAsync());
    // LiveKitConnectionCubit.stopRecording();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: BlocConsumer<LiveKitConnectionCubit, LiveKitConnectionState>(
        listener: (context, state) async {
          // final cubit = context.read<LiveKitConnectionCubit>();
          final messenger = ScaffoldMessenger.of(context);

          switch (state.inviteStatus) {
            case InviteStatus.sending:
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text("Sending invite...")),
                );
              break;

            case InviteStatus.success:
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.inviteMessage ?? "Invite sent")),
                );

              // reset to idle so it doesn’t repeat
              _lkCubit.resetInviteStatus();
              break;

            case InviteStatus.failure:
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.inviteMessage ?? "Invite failed"),
                  ),
                );

              _lkCubit.resetInviteStatus();
              break;

            case InviteStatus.idle:
              break;
          }

          // Data received
          if (state.dataReceivedText != null) {
            final text = state.dataReceivedText!;
            _lkCubit.clearUiEvents(); // clear FIRST
            await context.showDataReceivedDialog(text);
          }

          // Play audio manually (iOS safari)
          if (state.showPlayAudioManuallyDialog == true) {
            _lkCubit.clearUiEvents(); // clear FIRST
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final result = await context.showPlayAudioManuallyDialog();
              if (!context.mounted) return;
              if (result == true) {
                await _lkCubit.startAudioPlayback();
              }
            });
          }

          // Publish confirm
          if (state.needsPublishConfirm) {
            _lkCubit.clearPublishConfirm(); // clear FIRST so it won't re-trigger
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final result = await context.showPublishDialog();
              if (!context.mounted) return;
              if (result == true) {
                await _lkCubit.enableMic();
              }
            });
          }

          // // Recording status dialog
          // if (state.showRecordingStatusDialog == true) {
          //   cubit.clearUiEvents(); // clear FIRST to avoid repeated re-entry
          //   WidgetsBinding.instance.addPostFrameCallback((_) async {
          //     final result = await context.showRecordingStatusChangedDialog();
          //     if (!context.mounted) return;
          //     if (result == true) {
          //       await cubit.enableMic();
          //     }
          //   });
          // }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: _bottomCallControls(state.isHost),
            body: SafeArea(
              child: Column(
                children: [
                  _topHeader(state),
                  SizedBox(height: 1.3.height),
                  _topicCard(context, state),

                  Column(
                    children: [
                      _participantsGrid(state, context),
                      SizedBox(height: 1.height),
                      if (state.recordingStatus ==
                              LiveKitRecordingStatus.recording ||
                          state.recordingStatus ==
                              LiveKitRecordingStatus.paused)
                        const AudioWaveDesign(),
                    ],
                  ),

                  // else
                  //   Column(
                  //     children: [
                  //       _participantsGrid(state, context),
                  //       SizedBox(height: 1.height),
                  //       if (state.recordingStatus ==
                  //               LiveKitRecordingStatus.recording ||
                  //           state.recordingStatus ==
                  //               LiveKitRecordingStatus.paused)
                  //         const AudioWaveDesign(),
                  //     ],
                  //   ),
                  // if (state.recordingStatus == LiveKitRecordingStatus.idle)
                  //   InkWell(
                  //     highlightColor: Colors.transparent,
                  //     hoverColor: Colors.transparent,
                  //     splashColor: Colors.transparent,
                  //     onTap: () {
                  //       Navigator.pushNamed(
                  //         context,
                  //         RoutesName.INCOMING_CALL_FULL_SCREEN,
                  //       );
                  //     },
                  //     child: const Text(
                  //       "Incoming call Screen test for click here",
                  //     ),
                  //   ),
                  // if (state.recordingStatus == LiveKitRecordingStatus.idle)
                  //   SizedBox(height: 1.3.height),
                  // if (!widget.incomingCall)
                  //   _recordingSection(state, context)
                  // else if (state.recordingStatus ==
                  //         LiveKitRecordingStatus.recording ||
                  //     state.recordingStatus == LiveKitRecordingStatus.paused)
                  //   _incomingCallRecordingSection(state, context)
                  // else
                  //   incomingRecordingCard(state),
                  if (!state.isHost && state.consentGiven != true) ...[
                    const SizedBox.shrink(),
                  ] else if (state.isHost) ...[
                    _recordingSection(state, context), // host controls
                  ] else ...[
                    _inviteeRecordingView(state),
                  ],
                  SizedBox(height: 5.height),
                  Expanded(
                    child:
                        state.participantTracks.isNotEmpty
                            ? ParticipantWidget.widgetFor(
                              state.participantTracks.first,
                              showStatsLayer: true,
                            )
                            : const SizedBox.shrink(),
                  ),
                  // if (state.room?.localParticipant != null)
                  //   SafeArea(
                  //     top: false,
                  //     child: ControlsWidget(
                  //       state.room!,
                  //       state.room!.localParticipant!,
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inviteeRecordingView(LiveKitConnectionState state) {
    if (state.recordingStatus == LiveKitRecordingStatus.completed) {
      return _doneRecordingCard(state); // same as host
    }

    // If host is recording or paused: show waves + timer + white pill status
    if (state.recordingStatus == LiveKitRecordingStatus.recording ||
        state.recordingStatus == LiveKitRecordingStatus.paused) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Recording Time :",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: AppColors.dart_grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Utils.formatDurationHours(state.duration),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // ✅ white pill status like design
            _inviteeStatusPill(state),
          ],
        ),
      );
    }

    // idle -> show "Recording not started" info card
    return incomingRecordingCard(state);
  }

  Widget _inviteeStatusPill(LiveKitConnectionState state) {
    final isPaused = state.recordingStatus == LiveKitRecordingStatus.paused;
    final dotColor = isPaused ? AppColors.yellow : AppColors.redColor;
    final text = isPaused ? "Recording Paused" : "Now Recording";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.blackColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void showConsentDialog(BuildContext roomPageContext) {
    showDialog(
      context: roomPageContext,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return Dialog(
          backgroundColor: AppColors.dart_purple_Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: BlocBuilder<LiveKitConnectionCubit, LiveKitConnectionState>(
            builder: (context, state) {
              final liveKitCubit = roomPageContext.read<LiveKitConnectionCubit>();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              AppStrings.invitedIncomingCallPodcast,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        AppStrings.invitedIncomingCallDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        liveKitCubit.setConsent(true);
                      },
                      child: Text(
                        "Okay",
                        style: GoogleFonts.poppins(
                          color: AppColors.light_pink_Text_Color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     // Expanded(
                    //     //   child: TextButton(
                    //     //     onPressed: () async {
                    //     //       Navigator.of(dialogCtx).pop();
                    //     //
                    //     //       await liveKitCubit.disconnect();
                    //     //
                    //     //       if (!roomPageContext.mounted) return;
                    //     //
                    //     //       if (Navigator.of(roomPageContext).canPop()) {
                    //     //         Navigator.of(roomPageContext).pop();
                    //     //       } else {
                    //     //         Navigator.pushReplacementNamed(
                    //     //           roomPageContext,
                    //     //           RoutesName.MY_PODCAST_SCREEN,
                    //     //           arguments: {"isStartFirstTime": true},
                    //     //         );
                    //     //       }
                    //     //     },
                    //     //     child: Text(
                    //     //       "Decline",
                    //     //       style: GoogleFonts.poppins(
                    //     //         color: AppColors.light_pink_Text_Color,
                    //     //         fontSize: 14,
                    //     //         fontWeight: FontWeight.w600,
                    //     //       ),
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     // Container(
                    //     //   color: AppColors.whiteColor,
                    //     //   height: 21,
                    //     //   width: 2,
                    //     // ),
                    //     Expanded(
                    //       child:
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _bottomCallControls(bool isHost) {
    return BlocConsumer<LiveKitConnectionCubit, LiveKitConnectionState>(
      listener: (context, state) {
        if (state.callStatus != CallStatus.disconnected) return;
        if (state.callStatus == CallStatus.disconnected && state.isHost) {
          Navigator.pushReplacementNamed(
            context,
            RoutesName.AUDIO_PREVIEW_EDIT_SCREEN,
            arguments: {
              "audioPath": "assets/images/test_audio.mp3",
              "is_draft": false,
              "participants":
                  state.participants.length - 1 == 1
                      ? state.participants[1].firstName
                      : "",
            },
          );
        } else if (state.callStatus == CallStatus.disconnected && !state.isHost){
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.pushReplacementNamed(context, RoutesName.MY_PODCAST_SCREEN);
          }
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _circleBtn(
                state.isSpeaker == false ? Icons.volume_off : Icons.volume_up,
                color: AppColors.dart_grey,
                isDisable: state.isSpeaker ?? true,
                pressed: () {
                  context.read<LiveKitConnectionCubit>().speakerONOff();
                },
              ),
              _circleBtn(
                // Icons.mic_off,
                state.isMic == false ? Icons.mic_off : Icons.mic,
                color: AppColors.dart_grey,
                isDisable: state.isMic ?? false,
                pressed: () {
                  context.read<LiveKitConnectionCubit>().micONOff();
                },
              ),
              _circleBtn(
                Icons.call_end,
                color: AppColors.redColor,
                isDisable: true,
                isRed: true,
                pressed: () async {
                  final cubit = context.read<LiveKitConnectionCubit>();
                  await cubit.endCall(); // should disconnect inside
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circleBtn(
    IconData icon, {
    Color? color,
    bool isDisable = false,
    bool isRed = false,
    required VoidCallback pressed,
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: pressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDisable ? color : AppColors.dart_grey.withValues(alpha: 0.6),
        ),
        child: Icon(
          icon,
          color:
              isDisable
                  ? isRed
                      ? Colors.white
                      : Colors.black
                  : Colors.white,
        ),
      ),
    );
  }

  Widget incomingRecordingCard(LiveKitConnectionState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recording Not Started!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.height),
          Text(
            "The host hasn’t started recording this podcast yet.\n You’ll be included automatically once recording begins.\n Please stay in the room.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  // Widget _incomingCallRecordingSection(
  //   LiveKitConnectionState state,
  //   BuildContext context,
  // ) {
  //   if (state.recordingStatus == LiveKitRecordingStatus.completed) {
  //     return _doneRecordingCard(state);
  //   }
  //
  //   if (state.recordingStatus == LiveKitRecordingStatus.recording ||
  //       state.recordingStatus == LiveKitRecordingStatus.paused) {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       child: Column(
  //         children: [
  //           SizedBox(height: 1.5.height),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Column(
  //                 children: [
  //                   Text(
  //                     "Recording Time :",
  //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w700,
  //                       fontStyle: FontStyle.italic,
  //                       color: AppColors.dart_grey,
  //                     ),
  //                   ),
  //                   SizedBox(height: 1.height),
  //                   Text(
  //                     Utils.formatDuration(state.duration),
  //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   SizedBox(height: 1.height),
  //                   nowRecordingCard(state),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return Column(
  //     children: [
  //       MicButton(
  //         label: "Record",
  //         icon: Images.mic,
  //         isRounded: false,
  //         isRedColor: true,
  //         onPressed: () {
  //           context.read<LiveKitConnectionCubit>().startRecording();
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget nowRecordingCard(LiveKitConnectionState state) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 30,
        width: 136,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                      AppColors.whiteColor,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),

              /// 💡 Center light
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.bottomCenter,
                    radius: 1.0,
                    colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),

              /// 🎨 Grain texture
              CustomPaint(painter: GrainPainter()),

              /// 🔤 Content
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(
                        color:
                            state.recordingStatus ==
                                    LiveKitRecordingStatus.paused
                                ? AppColors.yellow
                                : AppColors.redColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        state.recordingStatus == LiveKitRecordingStatus.paused
                            ? "Recording paused"
                            : "Now Recording",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recordingSection(LiveKitConnectionState state, BuildContext context) {
    if (state.recordingStatus == LiveKitRecordingStatus.completed) {
      return _doneRecordingCard(state);
    }

    if (state.recordingStatus == LiveKitRecordingStatus.recording ||
        state.recordingStatus == LiveKitRecordingStatus.paused) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _waveform(),
            // const AudioWaveDesign(),
            // const SizedBox(height: 8),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MicButton(
                  isSVG: true,
                  isRounded: true,
                  isRedColor: false,
                  icon:
                      state.recordingStatus == LiveKitRecordingStatus.paused
                          ? Images.microphone
                          : Images.pause,
                  label:
                      state.recordingStatus == LiveKitRecordingStatus.paused
                          ? "Resume Recording"
                          : "Pause Recording",
                  onPressed: () {
                    state.recordingStatus == LiveKitRecordingStatus.paused
                        ? context
                            .read<LiveKitConnectionCubit>()
                            .resumeRecording()
                        : context
                            .read<LiveKitConnectionCubit>()
                            .pauseRecording();
                  },
                ),
                Column(
                  children: [
                    Text(
                      "Recording Time :",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.dart_grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Utils.formatDurationHours(state.duration),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                MicButton(
                  isSVG: true,
                  label: "Stop recording",
                  icon: Images.stop,
                  isRounded: true,
                  isRedColor: true,
                  onPressed: () {
                    context.read<LiveKitConnectionCubit>().stopRecording();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 22.height),
        MicButton(
          label: "Record",
          icon: Images.mic,
          isRounded: false,
          isRedColor: true,
          onPressed: () {
            context.read<LiveKitConnectionCubit>().startRecording();
          },
        ),
      ],
    );
  }

  Widget _doneRecordingCard(LiveKitConnectionState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlueDark.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Congratulations!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.height),
              Text(
                "You’ve completed your podcast recording.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.height),
              Text(
                "Duration: ${Utils.formatDurationFromString(state.duration.toString())}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.height),
              Text(
                "Topics: Growth, Friendship",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 1.height),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  textAlign: TextAlign.start,
                  "You can preview and manage this session after you leave the room. Take a moment to relax, your thoughts are safely saved.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _participantsGrid(LiveKitConnectionState state, BuildContext context) {
    const int maxItems = 4;

    final int participantCount = state.participants.length.clamp(0, maxItems);

    final bool showInvite =
        !widget.incomingCall && state.participants.length < 2;
    final plusUser = state.participants.length;

    final int itemCount = participantCount + (showInvite ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 17,
          mainAxisSpacing: 17,
        ),
        itemBuilder: (_, i) {
          if (i < participantCount) {
            return _userCard(state.participants[i], i, plusUser);
          }

          if (showInvite && i == participantCount) {
            return GestureDetector(
              onTap: () {
                showInviteDialog(context);
              },
              child:
                  widget.incomingCall ? const SizedBox.shrink() : _inviteCard(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _inviteCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dart_grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.user_plus,
            width: 32,
            height: 32,
            color: AppColors.blackColor,
          ),
          const SizedBox(height: 8),
          Text(
            "Invite People",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard(FriendsDataList user, int index, int plusUser) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.gray_light,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.Border_Color, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 125,
            child: Stack(
              children: [
                user.profileImage != null &&
                        user.profileImage.toString().endsWith('/null') == false
                    ? Positioned(
                      bottom: -20,
                      left: 0,
                      right: 0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: ClipOval(
                          child: Image.network(
                            user.profileImage!,
                            fit: BoxFit.cover,
                            // 🔄 Loading state
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    : ClipOval(
                      child: Text(
                        user.firstName.toString().toUpperCase() ?? '',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
              ],
            ),
          ),
          const Spacer(),
          Align(
            alignment: AlignmentGeometry.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YouAudioWave(useName: user.firstName),
                if (index == 1 && plusUser >= 3) plushUser(plusUser),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget plushUser(plusUser) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFB8C0C0),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        "$plusUser+",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _topHeader(LiveKitConnectionState state) {
    String title = "Recording Not Started Yet";
    Color color = Colors.white;
    final other = state.participants.firstWhere(
          (p) => p.userIdPK != state.myUserId,
      orElse: () => FriendsDataList(firstName: ""),
    );
    final otherName = other.firstName ?? "";

    if (state.recordingStatus == LiveKitRecordingStatus.recording) {
      title = "Now Recording";
      color = AppColors.redColor;
    } else if (state.recordingStatus == LiveKitRecordingStatus.paused) {
      title = "Recording Paused";
      color = AppColors.yellow;
    } else if (state.recordingStatus == LiveKitRecordingStatus.completed) {
      title = "Done Recording";
      color = AppColors.green_Color;
    }

    Widget buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          // Navigator.pop(context);
        },
        child: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.white,
          size: 25,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackButton(),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                  "${state.myUserName}, ${widget.incomingCall ? "you" : otherName}",

                  // "${state.myUserName},${widget.incomingCall
                //     ? "you"
                //     : state.participants.length - 1 == 1
                //     ? state.participants[1].firstName
                //     : ""} ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              print("Add Button Clicked");
              showInviteDialog(context);
            },
            child: SvgPicture.asset(Images.user_plus, width: 24, height: 24),
          ),
        ],
      ),
    );
  }

  Widget _topicCard(BuildContext context, LiveKitConnectionState state) {
    if (state.isLoading) {
      return const CircularProgressIndicator();
    }

    if (state.filteredTopics.isEmpty) return const SizedBox();
    final topic = state.filteredTopics[state.currentTopicIndex];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlueDark, AppColors.primaryBlueDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP CHIPS
          Row(
            children: [
              Text(
                "Topics :",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),

              /// SHUFFLE
              GestureDetector(
                onTap: () {
                  context.read<LiveKitConnectionCubit>().shuffleTopics(
                    TopicCategory.Shuffle,
                  );
                },
                child: _topicChip(
                  icon: Icons.shuffle,
                  label: "Shuffle",
                  selected: state.selectedCategory == TopicCategory.Shuffle,
                ),
              ),

              /// FAMILY
              GestureDetector(
                onTap: () {
                  context.read<LiveKitConnectionCubit>().filterByCategory(
                    TopicCategory.family,
                  );
                },
                child: _topicChip(
                  label: "Family",
                  selected: state.selectedCategory == TopicCategory.family,
                ),
              ),

              /// RELATIONSHIP
              GestureDetector(
                onTap: () {
                  context.read<LiveKitConnectionCubit>().filterByCategory(
                    TopicCategory.relationship,
                  );
                },
                child: _topicChip(
                  label: "Relationship",
                  selected:
                      state.selectedCategory == TopicCategory.relationship,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 TOPIC TEXT
          Center(
            child: Text(
              topic.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// 🔹 ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  enable: state.currentTopicIndex > 0,
                  btnText: "Previous",
                  height: 48,
                  onPressed: () {
                    context.read<LiveKitConnectionCubit>().previousTopic();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  enable:
                      state.currentTopicIndex < state.filteredTopics.length - 1,
                  btnText: "Next",
                  height: 48,
                  onPressed: () {
                    context.read<LiveKitConnectionCubit>().nextTopic();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topicChip({
    IconData? icon,
    required String label,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.purple400 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void showInviteDialog(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final liveKitCubit = context.read<LiveKitConnectionCubit>();

    // If your cubit has a method to fetch friends, call it here
    if ((homeCubit.state.friendsList ?? []).isEmpty) {
      homeCubit.getFriendsList(); // <- replace with your actual method name
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: homeCubit),
            BlocProvider.value(value: liveKitCubit),
          ],
          child: Dialog(
            backgroundColor: AppColors.dart_purple_Color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                final friends = homeState.friendsList ?? [];
                if (friends.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Not Friend Found"),
                  );
                }

                return BlocBuilder<
                  LiveKitConnectionCubit,
                  LiveKitConnectionState
                >(
                  builder: (context, lkState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    "Invite friend to podcast",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: friends.length,
                              itemBuilder: (_, i) {
                                final user = friends[i];
                                final id = user.userIdPK;
                                final isInvited =
                                    id != null &&
                                    lkState.invitedFriendIds.contains(id);

                                final isSending =
                                    lkState.inviteStatus ==
                                        InviteStatus.sending &&
                                    lkState.invitingFriendId == id;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      user.profileImage != null
                                          ? ClipOval(
                                            child: Image.network(
                                              user.profileImage!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,

                                              // // 🔄 Loading state
                                              // loadingBuilder: (
                                              //     context,
                                              //     child,
                                              //     loadingProgress,
                                              //     ) {
                                              //   if (loadingProgress == null)
                                              //     return child;
                                              //
                                              //   return const SizedBox(
                                              //     width: 50,
                                              //     height: 50,
                                              //     child: Center(
                                              //       child:
                                              //       CupertinoActivityIndicator(),
                                              //     ),
                                              //   );
                                              // },
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      const SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: Icon(
                                                          Icons.person,
                                                          color: Colors.white54,
                                                        ),
                                                      ),
                                            ),
                                          )
                                          : ClipOval(
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.deepOrangeAccent,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                (user.firstName?.isNotEmpty ==
                                                        true)
                                                    ? user.firstName![0]
                                                        .toUpperCase()
                                                    : "",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          user.firstName ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      if (isInvited)
                                        Text(
                                          "Invited",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white54,
                                          ),
                                        )
                                      else if (isSending)
                                        const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CupertinoActivityIndicator(),
                                        )
                                      else
                                        GestureDetector(
                                          onTap: () async {
                                            final cubit =
                                                context
                                                    .read<
                                                      LiveKitConnectionCubit
                                                    >();
                                            Navigator.pop(context);
                                            await cubit.inviteFriend(user);
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                Images.plus,
                                                width: 16,
                                                height: 16,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Invite",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors
                                                          .light_pink_Text_Color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
