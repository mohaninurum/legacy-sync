import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/audio_meta_widget.dart';
import 'package:legacy_sync/features/livekit_connection/presentation/utils/exts.dart';
import 'package:legacy_sync/features/my_podcast/presentation/bloc/my_podcast_cubit.dart';

import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../../../../core/images/images.dart';
import '../../../my_podcast/data/podcast_model.dart';
import '../bloc/audio_preview_edit_cubit.dart';
import '../bloc/audio_preview_edit_state.dart';
import '../widgets/audio_preview_controls_widgets.dart';

class AudioPreviewEditScreen extends StatefulWidget {
  final String? roomId;
  final PodcastModel? podcastModel;
  final bool isDraft;
  final bool isEditMode;
  final String participants;
  final String selectedTopicCategory;
  final int? durationSeconds;

  // final List<FriendsDataList>? participants;

  const AudioPreviewEditScreen({
    super.key,
    required this.roomId,
    this.podcastModel,
    required this.isDraft,
    this.isEditMode = false,
    required this.participants,
    required this.selectedTopicCategory,
    this.durationSeconds,
  });

  @override
  State<AudioPreviewEditScreen> createState() => _AudioPreviewEditScreenState();
}

class _AudioPreviewEditScreenState extends State<AudioPreviewEditScreen> {
  bool _picking = false;
  bool _hasNavigated = false;
  late final AudioPreviewEditCubit audioPreviewEditCubit;
  late final MyPodcastCubit _myPodcastCubit;
  bool _publishDialogShown = false;

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
        nav.pushNamedAndRemoveUntil(RoutesName.MY_PODCAST_SCREEN, (r) => false);
      }
    });
  }

  @override
  void initState() {
    _publishDialogShown = false;
    audioPreviewEditCubit = context.read<AudioPreviewEditCubit>();
    _myPodcastCubit = context.read<MyPodcastCubit>();
    audioPreviewEditCubit.setRoomId(widget.roomId);
    if (widget.podcastModel != null) {
      audioPreviewEditCubit.setData(data: widget.podcastModel!);
    }
    super.initState();
  }

  @override
  void dispose() {
    // cubitInstance.stopAndReset();
    super.dispose();
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
                      p.publishStatus != c.publishStatus ||
                      p.markFavStatus != c.markFavStatus ||
                      p.markUnFavStatus != c.markUnFavStatus ||
                      p.deleteStatus != c.deleteStatus,
              listener: (context, state) {
                if (state.deleteStatus == DeleteStatus.success) {
                  BotToast.showText(text: state.deleteMessage ?? "Draft deleted.");
                  _safeExitAfterSuccess();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    context.read<MyPodcastCubit>().fetchMyPodcastTab("Draft");
                  });
                }
                if (state.deleteStatus == DeleteStatus.failure) {
                  BotToast.showText(
                    text: state.deleteMessage ?? "Failed to delete draft",
                  );
                }
                if (state.markFavStatus == MarkFavStatus.success) {
                  BotToast.showText(text: state.markFavMessage ?? "Added To Favourites");
                  _myPodcastCubit.fetchFavouritePodcastList();
                  _myPodcastCubit.allPodcastsContinueListening();
                  _myPodcastCubit.fetchMyPodcastTab("Posted");
                }
                if (state.markUnFavStatus == MarkUnFavStatus.success) {
                  BotToast.showText(
                    text: state.markUnFavMessage ?? "Removed from favourites",
                  );
                  _myPodcastCubit.fetchFavouritePodcastList();
                  _myPodcastCubit.allPodcastsContinueListening();
                  _myPodcastCubit.fetchMyPodcastTab("Posted");
                }
                if (state.markFavStatus == MarkFavStatus.failure) {
                  BotToast.showText(text: state.markFavMessage ?? "Something went wrong");
                }
                if (state.markUnFavStatus == MarkUnFavStatus.failure) {
                  BotToast.showText(
                    text: state.markUnFavMessage ?? "Something went wrong",
                  );
                }
                if (state.saveAsDraftStatus == SaveAsDraftStatus.success) {
                  BotToast.showText(text: "Draft saved successfully.");
                  _safeExitAfterSuccess();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!context.mounted) return;
                    context.read<MyPodcastCubit>().fetchMyPodcastTab("Draft");
                  });
                  // Navigator.pop(context);
                } else if (state.saveAsDraftStatus == SaveAsDraftStatus.failure) {
                  BotToast.showText(
                    text: state.draftMessage ?? "Failed to save draft. Please try again.",
                  );
                }

                // Publish
                if (state.publishStatus == PublishStatus.success) {
                  BotToast.showText(text: "Podcast published successfully.");
                  if (_publishDialogShown) return;
                  _publishDialogShown = true;

                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (!mounted) return;

                    final ok =
                        await context.showPodcastPublishedDialog(); // your custom dialog
                    if (!mounted) return;

                    if (ok == true) {
                      _safeExitAfterSuccess();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!context.mounted) return;
                        context.read<MyPodcastCubit>().fetchMyPodcastTab("Posted");
                        context.read<MyPodcastCubit>().allPodcastsContinueListening();
                        context.read<MyPodcastCubit>().fetchFavouritePodcastList();
                      });
                    }
                  });
                } else if (state.publishStatus == PublishStatus.failure) {
                  _publishDialogShown = false;
                  BotToast.showText(text: state.publishMessage ?? "Failed to publish");
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
                      Visibility(visible: widget.isDraft, child: processingAudio(state)),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: widget.isDraft ? _draftControls() : _publishControls(),
        ),
      ),
    );
  }

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

  Widget readyToPublish(AudioPreviewEditState state, AudioPreviewEditCubit cubit) {
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
          AudioMetaWidget(
            state: state,
            participants: widget.participants,
            selectedTopicCategory: widget.selectedTopicCategory,
          ),
        ],
      ),
    );
  }

  Widget processingAudio(AudioPreviewEditState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topHeader(state),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 8.0),
            child: _SectionTitle("Processing your recording", context),
          ),
          const SizedBox(height: 6),
          processingNoticeCard(context: context),
          AudioMetaWidget(
            state: state,
            participants: widget.participants,
            selectedTopicCategory: widget.selectedTopicCategory,
          ),
        ],
      ),
    );
  }

  Widget _SectionTitle(String text, context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
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
            child: const Icon(Icons.schedule_rounded, color: AppColors.yellow, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your podcast is processing in the background. This usually takes 10 to 15 minutes. You can save it as a draft while we finish. Once processing is complete, you’ll be able to add a title, description, and publish.\n\nPublished episodes are only visible to participants from this recording session.",
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            "Learn more",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _topHeader(AudioPreviewEditState state) {
    Widget buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 23),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackButton(),
          if (!widget.isDraft)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !widget.isEditMode,
                  child: InkWell(
                    onTap: () {
                      if (state.isBookmark) {
                        final id = widget.podcastModel?.podcastId ?? 0;
                        if (id == 0) return; // safety
                        audioPreviewEditCubit.markUnFavourite(podcastId: id);
                      } else {
                        final id = widget.podcastModel?.podcastId ?? 0;
                        if (id == 0) return; // safety
                        audioPreviewEditCubit.markFavourite(podcastId: id);
                      }
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
                ),
                if (!widget.isEditMode && widget.podcastModel != null) ...[
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      Utils.showWarningDialog(
                        context: context,
                        title: "Delete Draft",
                        content: "Are you sure you want to delete this draft?",
                        actionsText: "Okay",
                        actionsText2: "Cancel",
                        okPressed: () {
                          final id = widget.podcastModel?.podcastId ?? 0;
                          context.read<AudioPreviewEditCubit>().deletePodcastDraft(
                            podcastId: id,
                          );
                        },
                        cancelPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 45,
                      height: 45,
                      child: const Icon(Icons.delete, color: Colors.white, size: 30),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _draftControls() {
    return BlocBuilder<AudioPreviewEditCubit, AudioPreviewEditState>(
      builder: (context, state) {
        final hasTitle = (state.title ?? '').trim().isNotEmpty;
        final hasDesc = (state.description ?? '').trim().isNotEmpty;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 12),

              Visibility(
                visible: widget.isDraft,
                child: Expanded(
                  child: CustomButton(
                    isOtherColor: true,
                    isDanger: widget.isDraft,
                    btnText: AppStrings.cancel,
                    height: 48,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Visibility(
                visible: widget.isDraft,
                child: Expanded(
                  child: CustomButton(
                    isOtherColor: false,
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
                        final hasTitle =
                            (context
                                .read<AudioPreviewEditCubit>()
                                .title
                                .text
                                .trim()
                                .isNotEmpty);

                        if (!hasTitle) {
                          BotToast.showText(text: "Please enter a title.");
                          return;
                        }

                        await context.read<AudioPreviewEditCubit>().saveAsDraft(
                          roomId: widget.roomId!,
                          topicType: widget.selectedTopicCategory,
                          durationSeconds: widget.durationSeconds ?? 0,
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _publishControls() {
    return BlocBuilder<AudioPreviewEditCubit, AudioPreviewEditState>(
      builder: (context, state) {
        final hasTitle = (state.title ?? '').trim().isNotEmpty;
        final hasDesc = (state.description ?? '').trim().isNotEmpty;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 12),

              Visibility(
                visible: !widget.isDraft,
                child: Expanded(
                  child: CustomButton(
                    isOtherColor: true,
                    enable: !widget.isDraft,
                    btnText: AppStrings.cancel,
                    height: 48,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Visibility(
                visible: !widget.isDraft,
                child: Expanded(
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
                            ? (widget.isEditMode ? "Updating..." : "Publishing...")
                            : (widget.isEditMode ? "Update" : "Publish"),
                    height: 48,
                    onPressed: () async {
                      if (widget.isDraft) {
                        BotToast.showText(
                          text: "Please wait 10–15 minutes. We’re still processing.",
                        );
                        return;
                      } else if (widget.podcastModel != null) {
                        if (hasTitle) {
                          if (widget.isEditMode) {
                            await context
                                .read<AudioPreviewEditCubit>()
                                .editPublishedPodcast(
                                  podcastId: widget.podcastModel!.podcastId,
                                  roomId: widget.podcastModel!.roomId ?? "",
                                  durationSeconds: state.duration.inSeconds,
                                );
                          } else {
                            await context.read<AudioPreviewEditCubit>().publishPodcast(
                              podcastId: widget.podcastModel!.podcastId,
                              durationSeconds: state.duration.inSeconds,
                            );
                          }
                        } else {
                          BotToast.showText(text: "Please fill title of the podcast.");
                        }
                      } else {
                        BotToast.showText(text: "PodcastId Is Missing");
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
          final value = await imagePicker.pickImage(source: ImageSource.gallery);
          if (value != null) {
            cubit.addCoverXFile(value);
            // cubit.addCover(value.path);
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
                      child: _coverWidget(state.coverImage!),
                    )
                    : const SizedBox.shrink(),
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

  Widget _coverWidget(String cover) {
    final v = cover.trim();
    if (v.isEmpty || v.endsWith("/null")) {
      return Image.asset(
        Images.podcast_thumbnail,
        fit: BoxFit.cover,
        height: 160,
        width: 160,
      );
    }
    if (v.startsWith("http://") || v.startsWith("https://")) {
      return Image.network(
        v,
        fit: BoxFit.cover,
        height: 160,
        width: 160,
        errorBuilder:
            (_, __, ___) => Image.asset(
              Images.podcast_thumbnail,
              fit: BoxFit.cover,
              height: 160,
              width: 160,
            ),
      );
    }
    return Image.file(
      File(v),
      fit: BoxFit.cover,
      height: 160,
      width: 160,
      errorBuilder:
          (_, __, ___) => Image.asset(
            Images.podcast_thumbnail,
            fit: BoxFit.cover,
            height: 160,
            width: 160,
          ),
    );
  }
}
