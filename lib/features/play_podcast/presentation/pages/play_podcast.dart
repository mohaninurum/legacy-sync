import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../../../../core/images/images.dart';
import '../../../my_podcast/data/podcast_model.dart';
import '../bloc/play_podcast_cubit.dart';
import '../bloc/play_podcast_state.dart';

class PlayPodcast extends StatefulWidget {
  final PodcastModel? podcast;
  final String audioPath;

  const PlayPodcast({Key? key,this.podcast,required this.audioPath}) : super(key: key);

  @override
  State<PlayPodcast> createState() => _PlayPodcastState();
}

class _PlayPodcastState extends State<PlayPodcast> {


  @override
  void initState() {
    context.read<PlayPodcastCubit>().loadAudio(widget.audioPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<PlayPodcastCubit, PlayPodcastState>(
            builder: (context, state) {
              final cubit = context.read<PlayPodcastCubit>();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _topHeader(state),
                    SizedBox(height: 2.height),
                    // addCover(state),
                    SizedBox(height: 1.height),
                    // title("Preview"),
                    // AudioPreviewControls(
                    //   state: state,
                    //   cubit: cubit,
                    //   audioPath: widget.audioPath,
                    // ),
                    // AudioMetaWidget(state: state,)
                  ],
                ),
              );
            },
          ),
        ),
        // bottomNavigationBar: _bottomControls(),
      ),
    );
  }

  Widget _topHeader(PlayPodcastState state) {
    Widget buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 40),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBackButton(),
          Text("Now Playing", style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
          InkWell(
            onTap: () {
              context.read<PlayPodcastCubit>().bookmark();
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


}