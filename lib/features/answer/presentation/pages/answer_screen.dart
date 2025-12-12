import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/app_sizes/app_sizes.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/audio_wave_form_widget.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_round.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/answer/presentation/bloc/answer_bloc/answer_cubit.dart';
import 'package:legacy_sync/features/answer/presentation/bloc/answer_state/answer_state.dart';
import 'package:camera/camera.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/db/shared_preferences.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../core/components/comman_components/locked_question_dialog.dart';
import '../../../home/domain/usecases/navigate_to_module_usecase.dart';
import '../../../home/presentation/bloc/home_bloc/home_cubit.dart';
import '../../../list_of_module/presentation/bloc/list_of_module_bloc/list_of_module_cubit.dart';
import '../widget/leave_page_dialog.dart';

class AnswerScreen extends StatefulWidget {
  final int qId;
  final int mIndex;
  final String questionText;
  final int moduleIndex;

  const AnswerScreen({super.key, required this.qId, required this.mIndex, this.questionText = "",required this.moduleIndex});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  TextEditingController _answerController = TextEditingController();
  VideoPlayerController? _videoPreviewController;
  bool isPopping = false;
  @override
  void initState() {
    super.initState();
    // print("qId: ${widget.qId}");
    _answerController = TextEditingController();

    // Add listener to track word count changes
    _answerController.addListener(() {
      context.read<AnswerCubit>().updateWordCount(_answerController.text);
    });
    context.read<AnswerCubit>().initialState();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _videoPreviewController?.dispose();
    super.dispose();
  }


  void _onCardTapped(int index) async {
    print("mudule index...$index");
    final cubit = context.read<HomeCubit>();
    print(cubit.state.journeyCards[index].title);
    print(cubit.state.journeyCards[index].id);
    final state = cubit.state;
    final card = state.journeyCards[index];
    print(index);
    print(card.id);
    print(card.title);
    final navigationArgs = NavigateToModuleUsecase.execute(card);
    final result = await Navigator.pushReplacementNamed(context, RoutesName.LIST_OF_MODULE, arguments: navigationArgs);
    if (result == true) {
      await context.read<HomeCubit>().startJourneyAnimation(index);
    }
    // if (state.journeyCards[index].isEnabled) {
    //   final card = state.journeyCards[index];
    //   print(card);
    //   final navigationArgs = NavigateToModuleUsecase.execute(card);
    //   final result = await Navigator.pushNamed(context, RoutesName.LIST_OF_MODULE, arguments: navigationArgs);
    //   if (result == true) {
    //     await context.read<HomeCubit>().startJourneyAnimation(index);
    //   }
    // } else {
    //   LockedQuestionDialog.show(context, title: "module");
    // }
  }




  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // If we triggered the pop manually → skip dialog
        if (isPopping) return;

        if (!didPop) {
          final confirm = await showLeavePageDialog(context);

          if (confirm == true) {
            // Mark that we are intentionally popping
            isPopping = true;
            context.read<AnswerCubit>().confirmLeave();
            Navigator.of(context).pop(false);

          }
        }
      },
      child: KeyboardDismissOnTap(
        child: BgImageStack(
          imagePath: Images.answer_bg,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
              body: MultiBlocListener(
                listeners: [
                  BlocListener<AnswerCubit, AnswerState>(
                    listenWhen: (prev, curr) => prev.transcribedText != curr.transcribedText,
                    listener: (context, state) {
                      // Append recognized text into the answer text field
                      _answerController.text = state.transcribedText;
                      _answerController.selection = TextSelection.fromPosition(TextPosition(offset: _answerController.text.length));
                    },
                  ),
                  BlocListener<AnswerCubit, AnswerState>(
                    listenWhen: (prev, curr) => prev.videoPath != curr.videoPath || prev.recordingState != curr.recordingState || prev.recordingType != curr.recordingType,
                    listener: (context, state) async {
                      // Initialize video preview when recording completes
                      if (state.recordingType == RecordingType.video && state.recordingState == RecordingState.completed && state.videoPath != null && state.videoPath!.isNotEmpty) {
                        try {
                          await _videoPreviewController?.dispose();
                          _videoPreviewController = VideoPlayerController.file(File(state.videoPath!));
                          await _videoPreviewController!.initialize();
                          await _videoPreviewController!.setLooping(true);
                          setState(() {});
                        } catch (e) {
                          print("Video preview initialization error: $e");
                        }
                      } else if (state.recordingType != RecordingType.video) {
                        // Dispose video preview when leaving video mode
                        await _videoPreviewController?.dispose();
                        _videoPreviewController = null;
                        if (mounted) setState(() {});
                      }
                    },
                  ),
                  BlocListener<AnswerCubit, AnswerState>(
                    listenWhen: (prev, curr) =>
                    prev.showCongratsDialog != curr.showCongratsDialog,
                    listener: (context, state) {
                      print("🎉 Congrats Listener fired = ${state.showCongratsDialog}");

                      if (state.showCongratsDialog == true) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.HOME_SCREEN,
                              (route) => false,
                        );


                      }
                      else if (state.showCongratsDialog == false) {
                        Navigator.pop(context);
                        // int index=widget.moduleIndex;
                        // _onCardTapped(index);
                      }
                    },
                  ),

                ],
                child: _buildBody(),
              ),
              bottomNavigationBar: BlocBuilder<AnswerCubit, AnswerState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state.recordingType == RecordingType.video && state.isCompleted,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                context.read<AnswerCubit>().stopSpeakingOnInteraction();
                                context.read<AnswerCubit>().retakeRecording();
                              },
                              btnText: "Retake",
                              enable: true,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                context.read<AnswerCubit>().stopSpeakingOnInteraction();
                                context.read<AnswerCubit>().submitFinalAnswer(widget.qId, _answerController.text, context, widget.mIndex);
                              },
                              btnText: "Continue",
                              enable: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        return LegacyAppBar(
          onBackPressed: () async {
            final confirm = await showLeavePageDialog(context);
            if (confirm == true) {
              isPopping = true;
              context.read<AnswerCubit>().confirmLeave();
              Navigator.of(context).pop(false);
            }
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [

        //   ElevatedButton(onPressed: () {
        // print(widget.mIndex);
        // print(widget.qId);
        // print(widget.questionText);
        // print(widget.moduleIndex);
        // int index=widget.moduleIndex;
        // _onCardTapped(index);
        //   }, child:Text("module check..")),


          _buildQuestionCard(), const SizedBox(height: 30), _buildAnswareOptions(), const SizedBox(height: 30), _buildActionButtons()]),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: widget.questionText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    height: 24,
                    width: 24,
                    margin: const EdgeInsets.only(left: 6),
                    child: AppButton(
                      onPressed: () {
                        final questionText = widget.questionText;
                        if (state.isSpeaking) {
                          context.read<AnswerCubit>().stopSpeaking();
                        } else {
                          context.read<AnswerCubit>().startSpeaking(questionText);
                        }
                      },
                      child: SizedBox(height: 24, width: 24, child: Center(child: SvgPicture.asset(state.isSpeaking ? Images.ic_stop_speaker_svg : Images.ic_speker_svg, height: 24, width: 24))),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildAnswareOptions() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.recordingType == RecordingType.none) _buildTextInputArea(state),
            if (state.recordingType == RecordingType.voice) _buildAudioWaveform(state),
            if (state.recordingType == RecordingType.video) _buildVideoContent(state),
          ],
        );
      },
    );
  }

  Widget _buildTextInputArea(AnswerState state) {
    return Column(
      children: [
        Container(
          height: 20.height,
          decoration: BoxDecoration(color: AppColors.bg_text_filed, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: TextField(
            controller: _answerController,
            maxLines: null,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w400),
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              context.read<AnswerCubit>().updateWordCount(_answerController.text);
            },
            decoration: InputDecoration(
              hintText:
                  state.recordingType == RecordingType.none
                      ? "Type Your Answer Here min 15 words..."
                      : "Add optional text to your ${state.recordingType == RecordingType.voice ? 'voice' : 'video'} answer...",
              hintStyle: TextTheme.of(context).bodyMedium!.copyWith(color: AppColors.whiteColor.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeight.w400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
        if (state.recordingType == RecordingType.none)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Text(
                  state.hasMinimumWords
                      ? ""
                      : _answerController.text.isEmpty
                      ? ""
                      : "Minimum: 15 words",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildVideoContent(AnswerState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 40.height,
          decoration: BoxDecoration(color: AppColors.primaryColorDull, borderRadius: BorderRadius.circular(30)),
          child: Stack(
            children: [
              // Video preview (live camera or recorded video)
              BlocBuilder<AnswerCubit, AnswerState>(
                builder: (context, s) {
                 if (s.cameraInitialized==true) {
                   return Container(color: Colors.black,);
                 }
                  // Show recorded video preview when completed
                  if (s.recordingState == RecordingState.completed && _videoPreviewController != null && _videoPreviewController!.value.isInitialized) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.height,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(width: _videoPreviewController!.value.size.width, height: _videoPreviewController!.value.size.height, child: VideoPlayer(_videoPreviewController!)),
                        ),
                      ),
                    );
                  }

                  // Show live camera preview when recording or not completed
                  final controller = context.read<AnswerCubit>().cameraController;
                  if (controller != null && controller.value.isInitialized) {
                     bool isFront =state.isFrontCamera;
                     //   if(state.recordingState == RecordingState.completed){
                     //     isFront=true;
                     //   }
                     //   print("isFront: $isFront");
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.height,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child:isFront  ?   Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(0),
                                child:  CameraPreview(controller),
                              ):CameraPreview(controller)

                                 )),
                        ),
                      ),
                    );
                  }

                  return Center(child: Icon(Icons.videocam, size: 64, color: AppColors.whiteColor.withValues(alpha: 0.5)));
                },
              ),



              if (state.recordingType== RecordingType.video && state.recordingState == RecordingState.idle)
                Positioned(
                  bottom: 20,
                  left: AppSizes.screenWidth / 3,
                  right: AppSizes.screenWidth / 3,
                  child: CustomButtonRound(
                    enable: false,
                    onPressed: () {
                      // Flip camera and start new recording

                      context.read<AnswerCubit>().flipCameraAndStartNew(isFront: false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Images.ic_flip_camera, height: 16, width: 16, color: AppColors.whiteColor),
                          const SizedBox(width: 10),
                          Text("Flip", style: TextTheme.of(context).bodyMedium!.copyWith(color: AppColors.whiteColor, fontSize: 14, fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),

              // Flash toggle button (top-left)
              if (state.isRecording || state.isPaused)
                // Positioned(
                //   top: 16,
                //   left: 16,
                //   child: GestureDetector(
                //     onTap: () => context.read<AnswerCubit>().toggleFlash(),
                //     child: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: const BoxDecoration(color: AppColors.primaryColorDull, shape: BoxShape.circle),
                //       child: Icon(state.isFlashOn ? Icons.flash_on : Icons.flash_off, color: state.isFlashOn ? Colors.yellow : AppColors.whiteColor, size: 20),
                //     ),
                //   ),
                // ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: CustomButtonRound(
                    enable: false,
                    onPressed: () {
                      context.read<AnswerCubit>().toggleFlash();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(state.isFlashOn ? Icons.flash_on : Icons.flash_off, color: state.isFlashOn ? Colors.yellow : AppColors.whiteColor, size: 20),
                    ),
                  ),
                ),

              // Speed control button
              if (state.isRecording || state.isPaused)
                Positioned(
                  top: 10,
                  right: 10,
                  child: CustomButtonRound(
                    enable: false,
                    onPressed: () {
                      context.read<AnswerCubit>().cyclePlaybackSpeed();
                    },
                    child: Padding(padding: const EdgeInsets.all(10), child: Text(state.speedLabel, style: const TextStyle(color: AppColors.whiteColor, fontSize: 14, fontWeight: FontWeight.bold))),
                  ),
                ),

              // Play/pause controls for completed video preview
              if (state.isCompleted)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_videoPreviewController != null && _videoPreviewController!.value.isInitialized) {
                        if (_videoPreviewController!.value.isPlaying) {
                          _videoPreviewController!.pause();
                          context.read<AnswerCubit>().pauseVideoPreview();
                        } else {
                          _videoPreviewController!.play();
                          context.read<AnswerCubit>().playVideoPreview();
                        }
                        setState(() {});
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          onPressed: () {
                            // Skip backward 5 seconds
                            if (_videoPreviewController != null && _videoPreviewController!.value.isInitialized) {
                              final currentPosition = _videoPreviewController!.value.position;
                              final newPosition = currentPosition - const Duration(seconds: 5);
                              _videoPreviewController!.seekTo(newPosition >= Duration.zero ? newPosition : Duration.zero);
                            }
                          },
                          child: SvgPicture.asset(Images.second_reverse_svg, height: 28, width: 28),
                        ),
                        const SizedBox(width: 40),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: (_videoPreviewController?.value.isPlaying ?? false) ? Colors.transparent : const Color(0xFF6F6F70), shape: BoxShape.circle),
                          child: SvgPicture.asset((_videoPreviewController?.value.isPlaying ?? false) ? Images.ic_pause_svg : Images.ic_play_svg, height: 25, width: 25),
                          // child: Icon((_videoPreviewController?.value.isPlaying ?? false) ? Icons.pause : Icons.play_arrow, color: AppColors.whiteColor, size: 40),
                        ),
                        const SizedBox(width: 40),
                        AppButton(
                          onPressed: () {
                            // Skip forward 5 seconds
                            if (_videoPreviewController != null && _videoPreviewController!.value.isInitialized) {
                              final currentPosition = _videoPreviewController!.value.position;
                              final maxPosition = _videoPreviewController!.value.duration;
                              final newPosition = currentPosition + const Duration(seconds: 5);
                              _videoPreviewController!.seekTo(newPosition <= maxPosition ? newPosition : maxPosition);
                            }
                          },
                          child: SvgPicture.asset(Images.second_forward_svg, height: 28, width: 28),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (state.recordingType == RecordingType.video && state.recordingState == RecordingState.completed) _buildTextInputArea(state),
      ],
    );
  }

  Widget buildAudioControl(BuildContext context, AnswerState state) {
    if (state.recordingState == RecordingState.recording) {
      return Image.asset(Images.ic_red_mic, height: 20, width: 20);
    }

    return GestureDetector(
      onTap: () {
        final cubit = context.read<AnswerCubit>();
        state.isAudioPlaying ? cubit.stopAudioPlayback() : cubit.playRecordedAudio();
      },
      child: SvgPicture.asset(state.isAudioPlaying ? Images.ic_pause_svg : Images.ic_play_svg, height: 20, width: 20),
    );
  }

  Widget _buildAudioWaveform(AnswerState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextInputArea(state),
        if(state.isAudioExist)
        Container(
          height: 60,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: AppColors.bg_text_filed, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              // Play button for completed recordings
              buildAudioControl(context, state),
              const SizedBox(width: 16),
              // Audio waveform using audio_waveforms package

              Expanded(
                child:
                    state.recordingState == RecordingState.recording
                        ? AudioWaveforms(
                          size: Size(MediaQuery.of(context).size.width - 120, 40),
                          recorderController: context.read<AnswerCubit>().recorderController,
                          waveStyle: WaveStyle(waveColor: AppColors.whiteColor.withValues(alpha: 0.9), extendWaveform: true, showMiddleLine: false, waveCap: StrokeCap.round),
                          enableGesture: false,
                          shouldCalculateScrolledPosition: false,
                        )
                        : state.isAudioPlaying
                        ? AudioFileWaveforms(
                          size: Size(MediaQuery.of(context).size.width - 120, 40),
                          playerController: context.read<AnswerCubit>().playerController,
                          playerWaveStyle: const PlayerWaveStyle(seekLineColor: AppColors.primaryColorBlue, showSeekLine: false, waveCap: StrokeCap.round),
                        )
                        : const AudioWaveformWidget(isPlaying: false, activeColor: Colors.white, inactiveColor: Colors.white),
              ),
              const SizedBox(width: 16),
              // Duration
              Text(state.formattedDuration, style: const TextStyle(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        if (state.recordingType == RecordingType.none) {
          return _buildInitialActionButtons();
        } else if (state.recordingType == RecordingType.voice) {
          return _buildVoiceActionButtons(state);
        } else if (state.recordingType == RecordingType.video) {

          return _buildVideoActionButtons(state);
        }
        return _buildInitialActionButtons();
      },
    );
  }

  Widget _buildInitialActionButtons() {
    return BlocConsumer<AnswerCubit, AnswerState>(
      listener: (context, state) {


      },
      builder: (context, state) {
        return Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_buildVoiceButton(), _buildVideoButton()]),
            if (state.shouldShowSubmitButton && state.recordingType == RecordingType.none)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomButton(
                  onPressed: () async {
                    context.read<AnswerCubit>().stopSpeakingOnInteraction();
                    context.read<AnswerCubit>().submitFinalAnswer(widget.qId, _answerController.text, context, widget.mIndex);
                  },
                  btnText: "Submit Answer",
                  enable: true,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildVoiceButton() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButtonRound(
              onPressed: () {
                context.read<AnswerCubit>().stopSpeakingOnInteraction();
                if (state.isRecording) {
                  context.read<AnswerCubit>().stopVoiceRecording();
                } else {
                  context.read<AnswerCubit>().startVoiceRecording();
                }
              },
              child: Padding(padding: const EdgeInsets.all(26), child: SvgPicture.asset(Images.ic_white_mic_svg, height: 24, width: 24)),
            ),
            const SizedBox(height: 12),
            Text(state.isVoiceRecording ? "Tap To Stop" : "Tap To Record", style: TextStyle(color: AppColors.whiteColor.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w400)),
            const SizedBox(height: 4),
            const Text("Voice Answer", style: const TextStyle(color: AppColors.whiteColor, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        );
      },
    );
  }

  Widget _buildVideoButton() {
    return BlocBuilder<AnswerCubit, AnswerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButtonRound(
              onPressed: () {
                context.read<AnswerCubit>().stopSpeakingOnInteraction();
                print("Video button tapped! Current state: ${state.recordingState}");
                if (state.isRecording) {
                  print("Stopping video recording...");
                  context.read<AnswerCubit>().stopVideoRecording();
                } else {
                  print("Starting video recording...");

                  context.read<AnswerCubit>().videoButtonIdle();
             //   context.read<AnswerCubit>().showVideoView();
                }
              },
              child: Padding(padding: const EdgeInsets.all(26), child: SvgPicture.asset(Images.ic_video_svg, height: 24, width: 24)),
            ),
            const SizedBox(height: 12),
            Text(state.isVideoRecording ? "Tap To Stop" : "Tap To Record", style: TextStyle(color: AppColors.whiteColor.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w400)),
            const SizedBox(height: 4),
            const Text("Video Answer", style: const TextStyle(color: AppColors.whiteColor, fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        );
      },
    );
  }

  Widget _buildVoiceActionButtons(AnswerState state) {
    if (state.isRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            icon: SvgPicture.asset(Images.ic_pause_svg, height: 24, width: 24),
            label: "Pause To Gather\nYour Thoughts",
            onTap: () {
              context.read<AnswerCubit>().stopSpeakingOnInteraction();
              context.read<AnswerCubit>().pauseVoiceRecording();
            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ),
          _buildActionButton(
            icon: SvgPicture.asset(Images.ic_check_svg, height: 24, width: 24),
            label: "Done\nRecording?",
            onTap: () {
              context.read<AnswerCubit>().stopSpeakingOnInteraction();
              context.read<AnswerCubit>().stopVoiceRecording();
            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ),
        ],
      );
    } else if (state.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            icon: SvgPicture.asset(Images.ic_white_mic_svg, height: 24, width: 24),
            label: "Continue Your\nTrain Of Thought",
            onTap: () {
              context.read<AnswerCubit>().stopSpeakingOnInteraction();
              context.read<AnswerCubit>().resumeVoiceRecording();
            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ),
          _buildActionButton(
            icon: SvgPicture.asset(Images.ic_check_svg, height: 24, width: 24),
            label: "Done\nRecording?",
            onTap: () {
              context.read<AnswerCubit>().stopSpeakingOnInteraction();
              context.read<AnswerCubit>().stopVoiceRecording();
            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ),
        ],
      );
    } else if (state.isCompleted) {
      return CustomButton(
        onPressed: () {
          context.read<AnswerCubit>().stopSpeakingOnInteraction();
          context.read<AnswerCubit>().submitFinalAnswer(widget.qId, _answerController.text, context, widget.mIndex);
        },
        btnText: "Continue",
        enable: true,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideoActionButtons(AnswerState state) {
    print("recordingType: ${state.recordingState}");
    if (state.recordingType== RecordingType.video && state.recordingState == RecordingState.idle){
      return   InkWell(
        onTap: () {
          // context.read<AnswerCubit>().videoButtonActive();
          print("Video button tapped! Current state 1: ${state.recordingState}");
          print("Video button tapped! Current state is paused: ${state.isPaused}");
           context.read<AnswerCubit>().stopSpeakingOnInteraction();
          if(state.isFrontCamera){
        print("front camera status: ${state.isFrontCamera}");
            context.read<AnswerCubit>().flipCameraAndStartNew(isFront: true);
          }else{
            print("rear camera status: ${state.isFrontCamera}");
            context.read<AnswerCubit>().videoButtonActive();
            context.read<AnswerCubit>().resumeVideoRecording();
          }

        },
        child: Container(
          padding: const EdgeInsets.symmetric( vertical: 8),
               width: 100,
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
          child: Center(child: SvgPicture.asset(Images.ic_video_svg, height: 30, width: 30)),
        ),
      );
    }
    if (state.isRecording || state.isPaused) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButton(
            icon: SvgPicture.asset(state.isPaused ? Images.ic_video_svg : Images.ic_pause_svg, height: 24, width: 24),
            label: state.isPaused ? "Continue Your\nTrain Of Thought" : "Pause To Gather\nYour Thoughts",
            onTap: () {
              print("start video....${state.isPaused}");
              context.read<AnswerCubit>().stopSpeakingOnInteraction();
              if (state.isPaused) {
                context.read<AnswerCubit>().resumeVideoRecording();
              } else {
                context.read<AnswerCubit>().pauseVideoRecording();
              }
            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ),

          _buildVideoSecondAndPauseWidget(state),
         state.isVideoProcess? _buildActionButton(
            icon: SvgPicture.asset(Images.video_process_loading, height: 24, width: 24),
            label: "Loading..",
            onTap: () {

            },
            color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
          ):_buildActionButton(
           icon: SvgPicture.asset(Images.ic_check_svg, height: 24, width: 24),
           label: "Done\nRecording?",
           onTap: () {
             context.read<AnswerCubit>().stopSpeakingOnInteraction();
             context.read<AnswerCubit>().stopVideoRecording();
           },
           color: AppColors.primaryColorBlue.withValues(alpha: 0.7),
         ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildVideoSecondAndPauseWidget(AnswerState state) {
    if (state.isPaused) {
      // return Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      //   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
      //   child: Center(child: Text(state.formattedDuration, style: const TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.normal))),
      // );

      return CustomButtonRound(
        enable: false,
        onPressed: () => {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Center(child: Text(state.formattedDuration, style: const TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.normal))),
        ),
      );
    } else if (state.isVideoRecording) {
      return
        CustomButtonRound(
        enable: false,
        onPressed: () => {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Center(child: Text(state.formattedDuration, style: const TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.normal))),
        ),
      );
      //   Container(
      //     padding: const EdgeInsets.symmetric( vertical: 11,),
      //     width: 95,
      //     decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
      //     alignment: Alignment.center,
      //     child: Text(state.formattedDuration, style: const TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.normal)),

          // Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   // Container(
          //   //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          //   //   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30)),
          //   //   child: Center(child: SvgPicture.asset(Images.ic_video_svg, height: 30, width: 30)),
          //   // ),
          //   // const SizedBox(height: 15),
          //
          // ],
          //       ),
        // );
    }
    return const SizedBox.shrink();
  }

  Widget _buildActionButton({required Widget icon, required String label, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CustomButtonRound(onPressed: onTap, child: Padding(padding: const EdgeInsets.all(26), child: icon)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: AppColors.whiteColor.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
