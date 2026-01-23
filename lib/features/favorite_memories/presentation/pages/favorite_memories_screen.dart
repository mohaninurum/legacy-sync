import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/curved_header_clipper.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_text.dart';

import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_state/favorite_memories_state.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/pages/widgets/f_question_card.dart';
import 'package:legacy_sync/features/my_podcast/data/podcast_model.dart';
import 'package:legacy_sync/features/my_podcast/presentation/bloc/my_podcast_cubit.dart';
import 'package:legacy_sync/features/play_podcast/presentation/bloc/play_podcast_cubit.dart';
import 'package:lottie/lottie.dart';

class FavoriteMemories extends StatefulWidget {
  const FavoriteMemories({super.key});

  @override
  State<FavoriteMemories> createState() => _FavoriteMemoriesState();
}

class _FavoriteMemoriesState extends State<FavoriteMemories> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final userID = await AppPreference().getInt(key: AppPreference.KEY_USER_ID);
    context.read<FavoriteMemoriesCubit>().loadQuestion(userID: userID);
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.f_bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<FavoriteMemoriesCubit, FavoriteMemoriesState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBgStackImageAndOptions(),
                  const SizedBox(height: 8),
                  _tabs(),
                  const SizedBox(height: 10),
                  _list(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tabs() => BlocBuilder<FavoriteMemoriesCubit, FavoriteMemoriesState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children:
          ["Memories", "Podcast"]
              .map(
                (tab) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color:
                    state.selectedTab == tab
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
                showCheckmark: false,
                backgroundColor: AppColors.primaryColorDull,
                selectedColor: AppColors.purple400,

                // label style control
                label: Text(
                  tab,
                  style: TextStyle(
                    color:
                    state.selectedTab == tab
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                selected: state.selectedTab == tab,
                onSelected: (_) {
                  context.read<FavoriteMemoriesCubit>().loadTab(tab);
                },
              ),
            ),
          )
              .toList(),
        ),
      );
    },
  );

  Widget _list() => BlocBuilder<FavoriteMemoriesCubit, FavoriteMemoriesState>(
    builder: (context, state) {
      // if (state.isLoading) {
      //   return const Center(child: SizedBox.shrink());
      // }

      if (state.podcasts.isEmpty) {
        return const Center(
          child: Text(
            "No podcasts found",
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return state.selectedTab == "Memories"
          ? SizedBox(
        height: 180,
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.favoriteQuestions.length ?? 0,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final data = state.favoriteQuestions[index];
            if (data.isHeader == true) {
              return GradientDividerText(text: data.moduleTitle ?? "");
            }
            return Padding(
              padding: EdgeInsets.only(bottom: index == ((state.favoriteQuestions.length ?? 0) - 1) ? 20 : 0),
              child: FQuestionCard(fromFriends: false, data: data, index: index, onTap: () {
                context.read<FavoriteMemoriesCubit>().expandCard(index: index);
              }),
            );
          },
        ),
      )
          : ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        itemCount: state.podcasts.length,
        itemBuilder: (_, i) {
          final data = state.podcasts[i];
          return myListPodcast(data, false);
        },
      );
    },
  );

  Widget myListPodcast(PodcastModel data, bool isContinueListening) {
    double progress = 0.0;
    String timeLeftText = "";
    if (isContinueListening) {
      progress = context.read<MyPodcastCubit>().listeningProgress(
        data.listenedSec,
        data.totalDurationSec,
      );
      timeLeftText = context.read<MyPodcastCubit>().timeLeftText(
        data.listenedSec,
        data.totalDurationSec,
      );
    }

    return InkWell(
      onTap: () async {
        // FilePickerResult? result = await FilePicker.platform.pickFiles();
        //
        // if (result != null) {
        //   File file = File(result.files.single.path!);
        // } else {
        //   // User canceled the picker
        // }


        // AudioOverlayManager.hide();
        context.read<PlayPodcastCubit>().loadOverlayAudioManager(false);



        context.read<MyPodcastCubit>().loadPodcast(data);
        // if(data.type == "Draft"){
        //   Navigator.pushNamed(
        //     context,
        //     RoutesName.AUDIO_PREVIEW_EDIT_SCREEN,
        //     arguments: {
        //       "audioPath": "assets/images/test_audio.mp3",
        //       "is_draft": true,
        //     },
        //   );
        // }else {
          Navigator.pushNamed(
            context,
            RoutesName.PLAY_PODCAST,
            arguments: {
              "podcast": data,
              "audioPath": data.audioPath,
              "isOverlayManager": false,
              "isContinue": false,
              "isFavorite": data.type == "Favorite" ? true : false,
            },
          ).then((value) {
            context.read<MyPodcastCubit>().allPodcastsContinueListening();
          },);
        // }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image);
                },
              ),
            ),

            const SizedBox(width: 12),

            /// TEXT COLUMN (TOP aligned – as you want)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      data.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  isContinueListening
                      ? const SizedBox.shrink()
                      : SizedBox(height: 1.height),
                  isContinueListening
                      ? const SizedBox.shrink()
                      : Text(
                    data.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  isContinueListening
                      ? SizedBox(height: 1.height)
                      : SizedBox(height: 1.height),
                  Row(
                    children: [
                      Text(
                        "Me  ",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dart_grey,
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
                        "  ${Utils.capitalize(data.relationship)}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dart_grey,
                        ),
                      ),
                    ],
                  ),
                  isContinueListening
                      ? SizedBox(height: 1.5.height)
                      : SizedBox(height: 1.height),
                  isContinueListening
                      ? Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress ?? 0,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFB388FF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeLeftText,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                      : SizedBox(height: 1.height),
                ],
              ),
            ),
            isContinueListening
                ? const SizedBox.shrink()
                : SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  data.duration,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 26.8.height,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipPath(
                clipper: CurvedHeaderClipper(),
                child: SizedBox(
                  height: 25.height,
                  child: Lottie.asset(
                    LottieFiles.favorite_header,
                    height: 25.height, // match parent height
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 60,
            left: 16,
            child: Row(
              children: [
                AppButton(
                  child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Text("Favorite Memories", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



