import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/play_podcast/presentation/pages/widget/audio_play_controller.dart';
import 'package:legacy_sync/features/play_podcast/presentation/pages/widget/bg_album_widget.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/images/images.dart';
import '../../../../core/utils/utils.dart';
import '../../../my_podcast/data/podcast_model.dart';
import '../../../my_podcast/presentation/bloc/my_podcast_cubit.dart';
import '../bloc/play_podcast_cubit.dart';
import '../bloc/play_podcast_state.dart';

class PlayPodcast extends StatefulWidget {
  final PodcastModel podcast;
  final String audioPath;
  final bool isOverlayManager;
  final bool isContinue;

  const PlayPodcast({
    super.key,
    required this.podcast,
    required this.audioPath,
    required this.isOverlayManager,
    required this.isContinue,
  });

  @override
  State<PlayPodcast> createState() => _PlayPodcastState();
}

class _PlayPodcastState extends State<PlayPodcast> {
  ScrollController scrollController = ScrollController();
  late final PlayPodcastCubit _cubit;
  late final MyPodcastCubit _myPodcastCubit;

  Future<void> _handleExit(PlayPodcastState state) async {
    final isFav = (widget.podcast.isFavourite == 1);
    if (isFav && state.isPlaying) {
      _cubit.loadOverlayAudioManager(true);
    } else {
      if (state.isPlaying) {
        _cubit.playPause();
      }
      _cubit.saveListenedPodcastTime(widget.podcast.podcastId ?? 0);
    }

    // then close the screen
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _cubit = context.read<PlayPodcastCubit>();
    _myPodcastCubit = context.read<MyPodcastCubit>();
    if (widget.isOverlayManager) {
    } else {
      _cubit.loadAudio(widget.audioPath, widget.podcast, widget.isContinue);
    }

    scrollController.addListener(() {
      print(scrollController.position.pixels);
      if (scrollController.position.pixels >= 50) {
        print("isScrollController::80");
        _cubit.isScrollController(true);
      } else {
        print("isScrollController::else");
        _cubit.isScrollController(false);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayPodcastCubit, PlayPodcastState>(
      listenWhen:
          (prev, curr) =>
              prev.markFavStatus != curr.markFavStatus ||
              prev.markUnFavStatus != curr.markUnFavStatus,
      listener: (context, state) {
        if (state.markFavStatus == MarkFavStatus.success) {
          BotToast.showText(text: state.markFavMessage ?? "Added To Favourites");
          _myPodcastCubit.fetchFavouritePodcastList();
        }
        if (state.markUnFavStatus == MarkUnFavStatus.success) {
          BotToast.showText(text: state.markUnFavMessage ??  "Removed from favourites");
          _myPodcastCubit.fetchFavouritePodcastList();
        }
        if (state.markFavStatus == MarkFavStatus.failure) {
          BotToast.showText(text: state.markFavMessage ?? "Something went wrong");
        }
        if (state.markUnFavStatus == MarkUnFavStatus.failure) {
          BotToast.showText(text: state.markUnFavMessage ??  "Something went wrong");
        }
      },
      builder: (context, state) {
        final cubit = context.read<PlayPodcastCubit>();
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return; // already popped by navigator
            await _handleExit(state);
          },
          child: BgAlbumWidget(
            isImage: true,
            url: state.podcast!.image,
            isDark: state.isScroll,
            child: Scaffold(
              backgroundColor:
                  state.isScroll
                      ? AppColors.primaryColorDull
                      : Colors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      _topHeader(state, cubit),
                      SizedBox(height: 2.height),
                      state.isScroll
                          ? albumCover(state.podcast?.image)
                          : const SizedBox.shrink(),
                      state.isScroll
                          ? SizedBox(height: 3.height)
                          : SizedBox(height: 48.height),
                      albumMetaData(widget.podcast),
                      SizedBox(height: 1.height),
                      AudioPlayController(state: state, cubit: cubit),
                      SizedBox(height: 3.5.height),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: _buildCardInfo(
                          "Description",
                          widget.podcast.description ?? "",
                        ),
                      ),
                      SizedBox(height: 3.height),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 7),
                      //   child: _buildCardInfo("Summary", widget.podcast.summary ?? ""),
                      // ),
                      // SizedBox(height: 3.height),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 7),
                      //   child: autoGeneratedTranscript(widget.podcast.summary ?? ""),
                      // ),
                      // SizedBox(height: 3.height),
                    ],
                  ),
                ),
              ),
              // bottomNavigationBar: _bottomControls(),
            ),
          ),
        );
      },
    );
  }

  Widget _topHeader(PlayPodcastState state, PlayPodcastCubit cubit) {
    Widget buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () async {
          await _handleExit(state);
        },
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 40,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackButton(),
          Text(
            "Now Playing",
            style: GoogleFonts.dmSerifDisplay(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (state.isBookmark) {
                final id = widget.podcast.podcastId ?? 0;
                if (id == 0) return; // safety
                _cubit.markUnFavourite(podcastId: id);
              } else {
                final id = widget.podcast.podcastId ?? 0;
                if (id == 0) return; // safety
                _cubit.markFavourite(podcastId: id);
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
        ],
      ),
    );
  }

  Widget albumCover(url) {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget albumMetaData(PodcastModel? podcast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              podcast?.title ?? "how to deal with anxiety",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 1.height),
          Row(
            children: [
              Text(
                "Me  ",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.dart_grey.withValues(alpha: 0.8),
                ),
              ),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dart_grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Text(
                "  ${Utils.capitalize(podcast?.relationship)}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.dart_grey.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfo(String description, String content) {
    return Container(
      width: 363.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueDark.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 2.height),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget autoGeneratedTranscript(String transcriptText) {
    return Container(
      width: 363.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueDark.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Auto Generated Transcript",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.transcript_description,
                    arguments: {"podcast": widget.podcast},
                  );
                },
                child: const Icon(
                  Icons.open_in_full,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "04:96 ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
              Text(
                " • ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                " Mom",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            transcriptText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
