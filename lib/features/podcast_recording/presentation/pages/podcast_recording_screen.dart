import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/podcast_recording/presentation/pages/widgets/audio_waves_desing.dart';
import 'package:legacy_sync/features/podcast_recording/presentation/pages/widgets/audio_waves_widget.dart';
import 'package:legacy_sync/features/podcast_recording/presentation/pages/widgets/record_button.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/custom_button.dart';
import '../../../../core/components/comman_components/custom_button_common_mask_widgets.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/images/images.dart';
import '../../data/user_list_model/user_list_model.dart';
import '../bloc/podcast_recording_cubit.dart';
import '../bloc/podcast_recording_state.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:file_picker/file_picker.dart';

class PodcastRecordingScreen extends StatefulWidget {
  final bool isIncomingCall;
  final String userName;
  const PodcastRecordingScreen({super.key,required this.isIncomingCall,required this.userName});

  @override
  State<PodcastRecordingScreen> createState() => _PodcastRecordingScreenState();
}

class _PodcastRecordingScreenState extends State<PodcastRecordingScreen> {


  @override
  void initState() {
    super.initState();
    context.read<PodCastRecordingCubit>().getInviteUse();
    context.read<PodCastRecordingCubit>().initiazeRecording();
    context.read<PodCastRecordingCubit>().loadTopics();
    context.read<PodCastRecordingCubit>().addSelfParticipant(widget.isIncomingCall);
    if(widget.isIncomingCall){
      Future.delayed(const Duration(seconds: 2),() {
        showIncomingCallDialog(context);

      },);

    }
  }

  @override
  void dispose() {
    context.read<PodCastRecordingCubit>().stopRecording();
    super.dispose();
  }


  incomingCallStartRecording(){
    context.read<PodCastRecordingCubit>().startRecording();
  }


  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
            builder: (context, state) {
              return Column(
                children: [
                  _topHeader(state),
                  SizedBox(height: 1.3.height),
                  _topicCard(context, state),
                  SizedBox(height: 0.5.height),
                  if(widget.isIncomingCall==false)
                  Expanded(
                    child: Column(
                      children: [
                        _participantsGrid(state, context),
                        SizedBox(height: 1.height),
                        if (state.status == PodCastRecordingStatus.recording ||
                            state.status == PodCastRecordingStatus.paused)
                          const AudioWaveDesign(),
                      ],
                    ),
                  )else
                    Column(
                      children: [
                        _participantsGrid(state, context),
                        SizedBox(height: 1.height),
                        if (state.status == PodCastRecordingStatus.recording ||
                            state.status == PodCastRecordingStatus.paused)
                          const AudioWaveDesign(),
                      ],
                    ),
                  if (state.status == PodCastRecordingStatus.idle)
                 InkWell(onTap: () {
                   Navigator.pushNamed(context, RoutesName.INCOMING_CALL_FULL_SCREEN);
                 }, child: const Text("Incoming call Screen test for click here")),
                  if (state.status == PodCastRecordingStatus.idle)
                  SizedBox(height: 1.3.height),
                 if(widget.isIncomingCall==false)
                  _recordingSection(state, context)
                  else if (state.status == PodCastRecordingStatus.recording ||
                   state.status == PodCastRecordingStatus.paused)
                    _incomingCallRecordingSection(state,context)
                 else _IncomingRecordingCard(state),
                  SizedBox(height: 5.height),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: _bottomCallControls(),
      ),
    );
  }

  Widget _topHeader(PodCastRecordingState state) {
    String title = "Recording Not Started Yet";
    Color color = Colors.white;

    if (state.status == PodCastRecordingStatus.recording) {
      title = "Now Recording";
      color = AppColors.redColor;
    } else if (state.status == PodCastRecordingStatus.paused) {
      title = "Recording Paused";
      color = AppColors.yellow;
    } else if (state.status == PodCastRecordingStatus.completed) {
      title = "Done Recording";
      color = AppColors.green_Color;
    }

    Widget _buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
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
          _buildBackButton(),
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
                "${widget.userName},${widget.isIncomingCall?"you":"Mom"} ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          InkWell(onTap: () {
            showInviteDialog(context);
          }, child: SvgPicture.asset(Images.user_plus, width: 24, height: 24)),
        ],
      ),
    );
  }

  Widget _participantsGrid(PodCastRecordingState state, BuildContext context) {
    const int maxItems = 4;

    final int participantCount = state.participants.length.clamp(0, 2);

    final bool showInvite =
        state.callStatus != CallStatus.connected &&
        state.participants.length < 2;
    final plusUser= state.participants.length;

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
            return _userCard(state.participants[i],i,plusUser);
          }

          if (showInvite && i == participantCount) {
            return GestureDetector(
              onTap: () {
                showInviteDialog(context);

                },
              child: widget.isIncomingCall? const SizedBox.shrink(): _inviteCard(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _recordingSection(PodCastRecordingState state, BuildContext context) {
    if (state.status == PodCastRecordingStatus.completed) {
      return _doneRecordingCard(state);
    }

    if (state.status == PodCastRecordingStatus.recording ||
        state.status == PodCastRecordingStatus.paused) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // _waveform(),
            // const AudioWaveDesign(),
            const SizedBox(height: 8),

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
                      state.status == PodCastRecordingStatus.paused
                          ? Images.microphone
                          : Images.pause,
                  label:
                      state.status == PodCastRecordingStatus.paused
                          ? "Resume Recording"
                          : "Pause Recording",
                  onPressed: () {
                    state.status == PodCastRecordingStatus.paused
                        ? context
                            .read<PodCastRecordingCubit>()
                            .resumeRecording()
                        : context
                            .read<PodCastRecordingCubit>()
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
                      Utils.formatDuration(state.duration),
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
                    context.read<PodCastRecordingCubit>().stopRecording();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        MicButton(
          label: "Record",
          icon: Images.mic,
          isRounded: false,
          isRedColor: true,
          onPressed: () {
            context.read<PodCastRecordingCubit>().startRecording();
          },
        ),
      ],
    );
  }


  Widget _incomingCallRecordingSection(PodCastRecordingState state, BuildContext context) {
    if (state.status == PodCastRecordingStatus.completed) {
      return _doneRecordingCard(state);
    }

    if (state.status == PodCastRecordingStatus.recording ||
        state.status == PodCastRecordingStatus.paused) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
             SizedBox(height: 1.5.height),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    SizedBox(height: 1.height),
                    Text(
                      Utils.formatDuration(state.duration),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                     SizedBox(height: 1.height),
                   nowRecordingCard(state),


                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        MicButton(
          label: "Record",
          icon: Images.mic,
          isRounded: false,
          isRedColor: true,
          onPressed: () {
            context.read<PodCastRecordingCubit>().startRecording();
          },
        ),
      ],
    );
  }

  Widget nowRecordingCard(PodCastRecordingState state){
    return  GestureDetector(
      onTap:() {

      },
      child: Container(
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
                    colors:
                    [
                    AppColors.whiteColor,
                    AppColors.whiteColor,
                    AppColors.whiteColor,
                    AppColors.whiteColor,
                    AppColors.whiteColor,
                    AppColors.whiteColor


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
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              /// 🎨 Grain texture
              CustomPaint(
                painter: GrainPainter(),
              ),

              /// 🔤 Content
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 6,
                    width: 6,
                    decoration: BoxDecoration(color:state.status == PodCastRecordingStatus.paused?AppColors.yellow: AppColors.redColor,borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                          state.status == PodCastRecordingStatus.paused?  "Recording paused": "Now Recording",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          )),
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


  Widget _doneRecordingCard(PodCastRecordingState state) {
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
  Widget _IncomingRecordingCard(PodCastRecordingState state) {
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

  void showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.dart_purple_Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
            builder: (context, state) {
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
                        itemCount: state.inviteUserList.length,
                        itemBuilder: (_, i) {
                          final user = state.inviteUserList[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                user.avatar != null
                                    ? ClipOval(
                                      child: Image.asset(
                                        user.avatar!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Text(
                                      user.name[0],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    user.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<PodCastRecordingCubit>()
                                        .addParticipant(user);
                                    Navigator.pop(context);


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
                                              AppColors.light_pink_Text_Color,
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
          ),
        );
      },
    );
  }

  void showIncomingCallDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.dart_purple_Color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
            builder: (context, state) {
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
                      style: Theme.of(
                      context,
                      ).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child:TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("Decline",   style:  GoogleFonts.poppins(
                          color: AppColors.light_pink_Text_Color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),)) ),
                        Container(color: AppColors.whiteColor,
                        height: 21,width: 2,),
                        Expanded(child:TextButton(onPressed: () {
                          Navigator.pop(context);
                          incomingCallStartRecording();
                        }, child: Text("Agree & Join",  style:  GoogleFonts.poppins(
                          color: AppColors.light_pink_Text_Color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),)) )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _waveform() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          24,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 3,
            height: (i % 2 == 0) ? 28 : 16,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _userCard(UserListModel user,int index,int plusUser) {
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
                user.avatar != null
                    ? Positioned(
                      bottom: -20,
                      left: 0,
                      right: 0,
                      child: Transform.scale(
                        scale: 1.5,
                        child: ClipOval(
                          child: Image.asset(user.avatar!, height: 125),
                        ),
                      ),
                    )
                    : Text(
                      user.avatar ?? 'M',
                      style: const TextStyle(fontSize: 22),
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
                YouAudioWave(useName: user.name),
                if(index==1&&plusUser>=3)
                plushUser(plusUser),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget plushUser(plusUser){
    return  Container(
      alignment: Alignment.center,
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFB8C0C0),
        borderRadius: BorderRadius.circular(50),
      ),
      child:  Text(
        "$plusUser+",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
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

  Widget _topicCard(BuildContext context, PodCastRecordingState state) {
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
                  context.read<PodCastRecordingCubit>().shuffleTopics(
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
                  context.read<PodCastRecordingCubit>().filterByCategory(
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
                  context.read<PodCastRecordingCubit>().filterByCategory(
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
                    context.read<PodCastRecordingCubit>().previousTopic();
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
                    context.read<PodCastRecordingCubit>().nextTopic();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomCallControls() {
    return BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
  builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _circleBtn(
            Icons.volume_up,
            color: AppColors.dart_grey,
            isDisable: state.isSpeaker??false,
            Pressed: () {
              context.read<PodCastRecordingCubit>().speakerONOff();
            },
          ),
          _circleBtn(
            Icons.mic_off,
            color: AppColors.dart_grey,
            isDisable: state.isMic??false,
            Pressed: () {
              context.read<PodCastRecordingCubit>().micONOff();
            },
          ),
          _circleBtn(
            Icons.call_end,
            color: AppColors.redColor,
            isDisable: true,
            isRed: true,
            Pressed: () async {
              context.read<PodCastRecordingCubit>().endCall();
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);
              } else {
                // User canceled the picker
              }
              Navigator.pushNamed(context, RoutesName.AUDIO_PREVIEW_EDIT_SCREEN,arguments: {
                "audioPath": result?.files.single.path,
                "is_draft":false
              });

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
    required VoidCallback Pressed,
  }) {
    return InkWell(
      onTap: Pressed,
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

  Widget audioWave(double level) {
    final heights = List.generate(20, (i) {
      return 6 + (level * 30 * (i.isEven ? 1 : 0.7));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          heights.map((h) {
            return Container(
              width: 3,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
    );
  }
}
