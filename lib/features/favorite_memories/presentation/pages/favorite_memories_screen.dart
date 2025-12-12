import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/curved_header_clipper.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_text.dart';

import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_state/favorite_memories_state.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/pages/widgets/f_question_card.dart';
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
            // if (state.favoriteQuestions.isEmpty) {
            //   return const Center(child: Text("No favorite questions found."));
            // }

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBgStackImageAndOptions(),
                  const SizedBox(height: 10),
                  ListView.separated(
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
                ],
              ),
            );
          },
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



