import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/config/routes/routes.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_common_mask_widgets.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/audio_meta_widget.dart';
import 'package:legacy_sync/features/home/data/model/friends_list_model.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/utils/exts.dart';
import 'package:legacy_sync/features/my_podcast/presentation/bloc/my_podcast_cubit.dart';

import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../../../../core/images/images.dart';
import '../../../my_podcast/data/podcast_model.dart';
import '../bloc/audio_preview_edit_cubit.dart';
import '../bloc/audio_preview_edit_state.dart';
import '../widgets/audio_preview_controls_widgets.dart';
import '../widgets/wave_slider_widges.dart';
import '../widgets/waveform_view_widget.dart';

class AudioPreviewEditScreen extends StatefulWidget {
  final String? roomId;
  final PodcastModel? podcastModel;
  final bool isDraft;
  final String participants;

  // final List<FriendsDataList>? participants;

  const AudioPreviewEditScreen({
    super.key,
    required this.roomId,
    this.podcastModel,
    required this.isDraft,
    required this.participants,
  });

  @override
  State<AudioPreviewEditScreen> createState() => _AudioPreviewEditScreenState();
}

class _AudioPreviewEditScreenState extends State<AudioPreviewEditScreen> {
  bool _picking = false;
  bool _hasNavigated = false;

  void _safeExitAfterSuccess() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    FocusManager.instance.primaryFocus?.unfocus(); // close keyboard

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final nav = Navigator.of(context);

      bool found = false;
      nav.popUntil((route) {
        if (route.settings.name == RoutesName.MY_PODCAST_SCREEN) {
          found = true;
          return true;
        }
        return false;
      });

      // ✅ If MY_PODCAST_SCREEN not in stack, go there explicitly
      if (!found) {
        nav.pushNamedAndRemoveUntil(
          RoutesName.MY_PODCAST_SCREEN,
              (r) => false,
        );
      }
    });
  }


  @override
  void initState() {
    if (widget.podcastModel != null) {
      context.read<AudioPreviewEditCubit>().setData(data: widget.podcastModel!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          final allow = await _confirmExitIfNeeded();
          if (allow == true && context.mounted) {
            _safeExitAfterSuccess();

            // Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocConsumer<AudioPreviewEditCubit, AudioPreviewEditState>(
              listenWhen:
                  (p, c) =>
                      p.saveAsDraftStatus != c.saveAsDraftStatus ||
                      p.publishStatus != c.publishStatus,
              listener: (context, state) {
                if (state.saveAsDraftStatus == SaveAsDraftStatus.success) {
                  BotToast.showText(text: "Draft saved successfully.");
                  // context.read<MyPodcastCubit>().fetchMyPodcastTab("Draft");
                  _safeExitAfterSuccess(); // ✅
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    context.read<MyPodcastCubit>().fetchMyPodcastTab("Draft");
                  });
                  // Navigator.pop(context);
                } else if (state.saveAsDraftStatus ==
                    SaveAsDraftStatus.failure) {
                  BotToast.showText(
                    text: "Failed to save draft. Please try again.",
                  );
                }

                // Publish
                if (state.publishStatus == PublishStatus.success) {
                  BotToast.showText(text: "Podcast published successfully.");
                  // context.read<MyPodcastCubit>().fetchMyPodcastTab("Posted");
                  _safeExitAfterSuccess(); // ✅
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    context.read<MyPodcastCubit>().fetchMyPodcastTab("Posted");
                  });
                  // Navigator.pop(context);
                } else if (state.publishStatus == PublishStatus.failure) {
                  BotToast.showText(
                    text: "Failed to publish. Please try again.",
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<AudioPreviewEditCubit>();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(
                        visible: !widget.isDraft,
                        child: readyToPublish(state, cubit),
                      ),
                      Visibility(
                        visible: widget.isDraft,
                        child: processingAudio(state),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: _bottomControls(),
        ),
      ),
    );
  }

  // void _safeExitAfterSuccess() {
  //   if (!mounted || _hasNavigated) return;
  //   _hasNavigated = true;
  //
  //   FocusManager.instance.primaryFocus?.unfocus(); // close keyboard
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //
  //     final nav = Navigator.of(context);
  //
  //     bool found = false;
  //     nav.popUntil((route) {
  //       if (route.settings.name == RoutesName.MY_PODCAST_SCREEN) {
  //         found = true;
  //         return true;
  //       }
  //       return false;
  //     });
  //
  //     // ✅ If MY_PODCAST_SCREEN not in stack, go there explicitly
  //     if (!found) {
  //       nav.pushNamedAndRemoveUntil(
  //         RoutesName.MY_PODCAST_SCREEN,
  //             (r) => false,
  //       );
  //     }
  //   });
  // }


  Future<bool> _confirmExitIfNeeded() async {
    final state = context.read<AudioPreviewEditCubit>().state;

    // If any action is loading, block leaving (optional but recommended)
    final isBusy =
        state.saveAsDraftStatus == SaveAsDraftStatus.loading ||
        state.publishStatus == PublishStatus.loading;

    if (isBusy) {
      BotToast.showText(text: "Please wait…");
      return false;
    }

    // Decide when to show warning:
    // - show when user is in edit flow (not draft processing screen)
    // - and not yet saved/published
    //
    // Adjust these conditions based on your real state flags.
    final shouldWarn = widget.isDraft;

    if (!shouldWarn) return true;

    final res = await context.showUnsavedPodcastDialog();
    return res == true;
  }

  Widget readyToPublish(
    AudioPreviewEditState state,
    AudioPreviewEditCubit cubit,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _topHeader(state),
          SizedBox(height: 2.height),
          addCover(state),
          SizedBox(height: 1.height),
          title("Preview"),
          AudioPreviewControls(
            state: state,
            cubit: cubit,
            audioPath:
                widget.podcastModel?.audioPath != null
                    ? widget.podcastModel!.audioPath.toString()
                    : '',
          ),
          AudioMetaWidget(state: state, participants: widget.participants),
        ],
      ),
    );
  }

  Widget processingAudio(AudioPreviewEditState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 8.0),
            child: _SectionTitle("Processing your recording", context),
          ),
          const SizedBox(height: 6),
          processingNoticeCard(context: context),
          AudioMetaWidget(state: state, participants: widget.participants),
        ],
      ),
    );
  }

  Widget _SectionTitle(String text, context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget processingNoticeCard({
    required BuildContext context,
    int minMinutes = 10,
    int maxMinutes = 15,
    VoidCallback? onLearnMore,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        color: AppColors.bg_container,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.yellow.withOpacity(0.14),
            ),
            child: const Icon(
              Icons.schedule_rounded,
              color: AppColors.yellow,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We’re processing your podcast recording in the background. This usually takes $minMinutes–$maxMinutes minutes. You can save it as a Draft for now. Once processing is complete, the Save button will be enabled so you can publish your podcast.",
                  // "It can take $minMinutes–$maxMinutes minutes before it’s ready. "
                  // "Once processing is complete, you’ll be able to save it.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.white.withOpacity(0.78),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white.withOpacity(0.08),
                      ),
                      child: Text(
                        "Usually ready soon",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (onLearnMore != null)
                      InkWell(
                        onTap: onLearnMore,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Text(
                            "Learn more",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.yellow,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topHeader(AudioPreviewEditState state) {
    Widget buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 23),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackButton(),
          const SizedBox(),
          InkWell(
            onTap: () {
              context.read<AudioPreviewEditCubit>().bookmark();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: state.isBookmark ? AppColors.yellow : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              width: 45,
              height: 45,
              child: ClipRect(
                child: Image.asset(
                  state.isBookmark ? Images.bookmarked : Images.bookmark,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomControls() {
    return BlocBuilder<AudioPreviewEditCubit, AudioPreviewEditState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  isOtherColor: true,
                  leftWidget:
                      state.saveAsDraftStatus == SaveAsDraftStatus.loading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.arrow_downward_rounded,
                            color: AppColors.whiteColor,
                          ),
                  enable: widget.isDraft,
                  btnText:
                      state.saveAsDraftStatus == SaveAsDraftStatus.loading
                          ? "Saving..."
                          : "Draft",
                  height: 48,
                  onPressed: () async {
                    if (widget.roomId != null) {
                      await context.read<AudioPreviewEditCubit>().saveAsDraft(
                        roomId: widget.roomId!,
                      );
                    } else {
                      BotToast.showText(text: "RoomId is missing");
                      return;
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  leftWidget:
                      state.publishStatus == PublishStatus.loading
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(
                            Icons.arrow_upward_rounded,
                            color: AppColors.whiteColor,
                          ),
                  enable: !widget.isDraft,
                  btnText:
                      state.publishStatus == PublishStatus.loading
                          ? "Publishing..."
                          : "Publish",
                  height: 48,
                  onPressed: () async {
                    if (widget.isDraft) {
                      BotToast.showText(
                        text:
                            "Please wait 10–15 minutes. We’re still processing.",
                      );
                      return;
                    } else if (widget.podcastModel != null) {
                      print("Comming :: ${widget.podcastModel!.podcastId}");
                      await context
                          .read<AudioPreviewEditCubit>()
                          .publishPodcast(
                            podcastId: widget.podcastModel!.podcastId,
                          );
                    } else {
                      BotToast.showText(text: "PodcastId Is Missing");
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget addCover(AudioPreviewEditState state) {
    return InkWell(
      onTap: () async {
        if (_picking) return;
        _picking = true;
        try {
          final cubit = context.read<AudioPreviewEditCubit>();
          final imagePicker = ImagePicker();
          final value = await imagePicker.pickImage(
            source: ImageSource.gallery,
          );
          if (value != null) {
            cubit.addCover(value.path);
          }
        } finally {
          _picking = false;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(24),
            ),
            child:
                state.coverImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _coverWidget(state.coverImage),
                    )
                    : SvgPicture.asset(
                      Images.microphone,
                      color: AppColors.DartGrey,
                      height: 55,
                      width: 55,
                    ),
          ),
          const SizedBox(height: 15),
          Text(
            "Add Cover",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverWidget(String? cover) {
    final v = (cover ?? '').trim();
    final isNetwork = v.startsWith('http://') || v.startsWith('https://');
    final isFileUri = v.startsWith('file://');

    if (v.isEmpty) {
      return SvgPicture.asset(
        Images.microphone,
        color: AppColors.DartGrey,
        height: 55,
        width: 55,
      );
    }

    if (isFileUri) {
      return Image.file(
        File(Uri.parse(v).toFilePath()),
        fit: BoxFit.cover,
        height: 160,
        width: 160,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else if (isNetwork) {
      return Image.network(
        v,
        fit: BoxFit.cover,
        height: 160,
        width: 160,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
      );
    }
    else {
      return SvgPicture.asset(
        Images.microphone,
        color: AppColors.DartGrey,
        height: 55,
        width: 55,
      );
    }
  }
}
