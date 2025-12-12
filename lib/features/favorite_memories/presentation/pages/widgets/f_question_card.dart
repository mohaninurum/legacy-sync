import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/audio_message_widget.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_round.dart';
import 'package:legacy_sync/core/components/comman_components/custom_video_player.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/favorite_memories/data/model/list_of_fav_que_model_data.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_state/favorite_memories_state.dart';
import 'package:legacy_sync/features/list_of_module/presentation/bloc/list_of_module_bloc/list_of_module_cubit.dart';
import 'package:lottie/lottie.dart';

class FQuestionCard extends StatelessWidget {
  final FavoriteModelData data;
  final VoidCallback onTap;
  final int index;
  final bool fromFriends;

  const FQuestionCard({required this.data, required this.onTap, required this.index, required this.fromFriends, super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Utils.hexToColor(data.activeColorCode ?? "#CCCCCC");

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(data.isExpanded! ? 0 : 16), topRight: const Radius.circular(16)),
              child: Lottie.asset(Utils.getModuleLottie(data.imageCode), height: 60, fit: BoxFit.cover),
            ),
          ),

          /// Animated expand/collapse
          Container(
            decoration: BoxDecoration(color:AppColors.blackColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                AppButton(
                  onPressed: () {
                    onTap();
                    if (data.isExpanded == false) {
                      if ((data.answers ?? []).isEmpty) {
                        //context.read<ListOfModuleCubit>().getExpandedCardData(questionId: data.questionidpK!, index: index);
                      }
                    }
                  },
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child:
                          AnimatedRotation(turns: data.isExpanded! ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: Image.asset(Images.ic_drop, height: 30, width: 30)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.width),
                            child: Text(
                              data.questionTitle ?? "",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.whiteColor, fontSize: 15, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              maxLines: data.isExpanded! ? 5 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Expandable Section
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  reverseDuration: const Duration(milliseconds: 0),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _buildStaticListContent(mIndex: index, mContext: context, qId: data.moduleId!, fromFriends: fromFriends,questionText:data.questionTitle??""),
                  ),
                  crossFadeState: data.isExpanded! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                  sizeCurve: Curves.fastEaseInToSlowEaseOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Static list items (dynamic later)
  Widget _buildStaticListContent({required int mIndex, required BuildContext mContext, required int qId, required bool fromFriends, required String questionText}) {
    return BlocBuilder<FavoriteMemoriesCubit, FavoriteMemoriesState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              itemCount: state.favoriteQuestions[mIndex].answers?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildListItem(parentIndex: mIndex, index: index, data: data.answers![index], icon: Icons.star, context: context, fromFriends: fromFriends);
              },
            ),
            const SizedBox(height: 20),
            // Visibility(visible: !fromFriends, child: _buildAddMoreButtons(mContext, qId, mIndex,questionText)),
            // const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildListItem({
    required int parentIndex,
    required int index,
    required Answers data,
    required IconData icon,
    required BuildContext context,
    required bool fromFriends,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.star_yellow, height: 16, width: 16),
            const SizedBox(width: 10),
            Text("Insight ${index + 1}", style: TextTheme.of(context).bodyMedium!.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
            const Spacer(),
            //Visibility(visible: !fromFriends, child: _buildMenuPopUp(parentIndex, index)),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 6),
          padding: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFF5176ba), width: 2))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              data.answerType == 2
                  ? AudioMessageWidget(audioUrl: data.answerMedia ?? "")
                  :data.answerType ==1? const SizedBox.shrink(): Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomVideoPlayer(borderRadius: BorderRadius.circular(10), height: 200, width: double.infinity, url: data.answerMedia ?? "", autoPlay: false, showControls: true),
                  ),
              if (data.answerText != null && data.answerText!.isNotEmpty) const SizedBox(height: 10),
              Text(data.answerText ?? "", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreButtons(BuildContext context, dynamic qId, int mIndex,String questionText) {
    return Row(
      children: [
        const SizedBox(width: 6),
        Expanded(
          child: CustomButton(
            onPressed: () async {
              final cubit = context.read<ListOfModuleCubit>();
              final state = cubit.state;
              final result = await Navigator.pushNamed(context, RoutesName.ANSWER_SCREEN, arguments: {"qId": qId, "mIndex": mIndex,"questionText":questionText});
              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insight added successfully")));
                // cubit.getExpandedCardData(questionId: qId, index: mIndex);
              }
            },
            btnText: "Add new insight",
          ),
        ),
        const SizedBox(width: 10),
        CustomButtonRound(onPressed: () {
          // context.read<FavoriteMemoriesCubit>().addFavQuestion(questionId: data.questionidpK);
        }, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18), child: Image.asset(Images.save_ic, height: 20, width: 20))),
      ],
    );
  }

  // Widget _buildMenuPopUp(parentIndex, index) {
  //   return PullDownButton(
  //     position: PullDownMenuPosition.automatic,
  //     itemBuilder:
  //         (context) => [
  //       PullDownMenuItem(onTap: () {}, title: "Edit", icon: CupertinoIcons.pencil),
  //       PullDownMenuItem(onTap: () {}, title: "Add Photo", icon: CupertinoIcons.camera),
  //       PullDownMenuItem(
  //         onTap: () {
  //           context.read<ListOfModuleCubit>().deleteAnswerOfModule(answerId: data.answers![index].answerIdPK!, parentIndex: parentIndex, index: index);
  //         },
  //         title: "Delete",
  //         icon: CupertinoIcons.delete,
  //         iconColor: Colors.red,
  //         isDestructive: true,
  //       ),
  //     ],
  //     buttonBuilder: (context, showMenu) => CupertinoButton(onPressed: showMenu, padding: EdgeInsets.zero, child: Image.asset(Images.menu_black, height: 16, width: 16)),
  //   );
  // }
}
