import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/app_network_image.dart';
import 'package:legacy_sync/core/components/comman_components/audio_message_widget.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_round.dart';
import 'package:legacy_sync/core/components/comman_components/custom_video_player.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_progress_bar.dart';
import 'package:legacy_sync/core/components/comman_components/will_pop_scope.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/favorite_memories/presentation/bloc/favorite_memories_bloc/favorite_memories_cubit.dart';
import 'package:legacy_sync/features/list_of_module/data/model/list_of_module_model.dart';
import 'package:legacy_sync/features/list_of_module/data/model/module_answer_model.dart';
import 'package:legacy_sync/features/list_of_module/presentation/bloc/list_of_module_bloc/list_of_module_cubit.dart';
import 'package:legacy_sync/features/list_of_module/presentation/bloc/list_of_module_state/list_of_module_state.dart';
import 'package:legacy_sync/features/list_of_module/presentation/widget/image_preview.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../../../config/db/shared_preferences.dart';
import '../../../../core/components/comman_components/congratulations_module_dialog.dart';
import '../../../../core/components/comman_components/locked_question_dialog.dart';
import '../../../answer/presentation/widget/leave_page_dialog.dart';
import '../../data/repositories/list_of_module_repository_impl.dart';

class ListOfModuleScreen extends StatefulWidget {
  final int moduleId;
  final int friendId;
  final bool fromFriends;
  final bool preExpanded;
  final String moduleTitle;
  final String moduleImage;

  const ListOfModuleScreen({super.key, required this.friendId, required this.moduleId, required this.moduleTitle, required this.moduleImage, required this.fromFriends, this.preExpanded = false});

  @override
  State<ListOfModuleScreen> createState() => _ListOfModuleScreenState();
}

class _ListOfModuleScreenState extends State<ListOfModuleScreen> {
  var isSubmitted='false';
  @override
  void initState() {
    context.read<ListOfModuleCubit>().isQuestionContinue(false);
    super.initState();
    _initializeData();


  }

  Future<void> _initializeData() async {
     isSubmitted=  await AppPreference().get(key: "SUBMITTED");
    context.read<ListOfModuleCubit>().loadQuestion(context: context, moduleId: widget.moduleId, friendId: widget.friendId, fromFriends: widget.fromFriends, preExpanded: widget.preExpanded);
  }

  @override
  Widget build(BuildContext context) {

    return AppWillPopScope(
      showDialog: false,
      onExit: (value) {
        if(isSubmitted=="true"){
          _initializeData();
        }
        final cubit = context.read<ListOfModuleCubit>();
        final state = cubit.state;
        List<QuestionItems> questions = state.data.questions ?? [];
        bool allUnlocked = questions.every((q) => q.islocked == false);
        if (allUnlocked) {
          if (questions[questions.length - 1].answers != null && questions[questions.length - 1].answers!.isNotEmpty) {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
          }
        } else {
          Navigator.pop(context);
        }
      },
      child: BgImageStack(
        imagePath: Images.bg_question,
        child: SafeArea(
          bottom: Platform.isIOS ? false : true,
          child: Scaffold(backgroundColor: Colors.transparent, body: _buildBody(widget.moduleId), bottomNavigationBar: Visibility(visible: !widget.fromFriends, child: _buildBottomButton(widget.moduleId))),
        ),
      ),
    );
  }

  Widget _buildBody(int moduleIndex) {
    print("moduleIndex: $moduleIndex");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
        const SizedBox(height: 20),
            _buildImage(),
            const SizedBox(height: 20),
            _buildTitleAndDescription(),
            const SizedBox(height: 24),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildTotalQuestionWidget(),
            const SizedBox(height: 20),
            _buildQuestionList(moduleIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(moduleIndex) {
    return BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
      builder: (context, state) {
        int totalQuestions = state.data.questions?.length ?? 0;
        // if (state.totalAnswered == totalQuestions) {
        //   return const SizedBox();
        // }
        int questionsNumber = (state.totalAnswered < totalQuestions) ? state.totalAnswered : totalQuestions;

        return Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 10, bottom: Platform.isIOS ? 4.height : 10),
          decoration: const BoxDecoration(color: AppColors.grilBlue),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Start Question $questionsNumber", style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 12, color: AppColors.yellowfad)),
                    Text(
                      state.currentQuestionItems.questiontitle ?? "",
                      style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: CustomButton(
                    isMoudel: true,
                    onPressed: () async {
                      final result = await Navigator.pushNamed(context, RoutesName.ANSWER_SCREEN, arguments: {"qId": state.currentQuestionItems.questionidpK, "mIndex": questionsNumber - 1});
                      if (result == true) {
                       context.read<ListOfModuleCubit>().isQuestionContinue(true);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insight added successfully")));
                        // cubit.getExpandedCardData(questionId: qId, index: mIndex);
                      }
                    },
                    btnText: state.isQuestionContinue? "Continue Module":"Start Module",
                    rightWidget: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Hero(
          tag: widget.moduleTitle,
          child: SizedBox(
            height: 30.height,
            child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Lottie.asset(widget.moduleImage, fit: BoxFit.fill, height: 30.height, width: double.infinity)),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: AppButton(
            onPressed: () async {

            if(isSubmitted=="true"){
              _initializeData();
            }

              ListOfModuleRepositoryImpl listOfModuleRepositoryImpl =ListOfModuleRepositoryImpl();
              //ListOfModuleRepositoryImpl
              // listOfModuleRepositoryImpl.getListOfModule(moduleID, userID);
              final cubit = context.read<ListOfModuleCubit>();
              final state = cubit.state;
              List<QuestionItems> questions = state.data.questions ?? [];
              bool allUnlocked = questions.every((q) => q.islocked == false);
              if (allUnlocked) {
                if (questions[questions.length - 1].answers != null && questions[questions.length - 1].answers!.isNotEmpty) {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }

              //
            },
            child: Image.asset(Images.ic_close, height: 32, width: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndDescription() {
    return BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
      builder: (context, state) {
        // Get title from API first, then fallback to passed title, then to a default
        String displayTitle = '';
        if (state.data.screentitle != null && state.data.screentitle!.isNotEmpty && state.data.screentitle != '') {
          displayTitle = state.data.screentitle!;
        } else if (widget.moduleTitle.isNotEmpty) {
          displayTitle = widget.moduleTitle;
          print("Using passed title: $displayTitle");
        } else {
          displayTitle = 'Module ${widget.moduleId}'; // Fallback title
          print("Using fallback title: $displayTitle");
        }

        print("Final display title: $displayTitle");
        print("API screentitle: '${state.data.screentitle}'");
        print("Widget moduleTitle: '${widget.moduleTitle}'");

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayTitle, style: TextTheme.of(context).bodyLarge!, textAlign: TextAlign.start),
            const SizedBox(height: 14),
            Text(state.data.screendescription ?? "", style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
      builder: (context, state) {
        final total = state.data.questions?.length ?? 0;
        final answered = state.totalAnswered;
        print("answered $answered");

        final percent = (answered == 0 || total == 0) ? 0 : ((answered / total) * 100).toInt();

        return Row(
          children: [
            Expanded(child: GradientProgressBar(currentStep: state.totalAnswered, totalSteps: state.data.questions?.length ?? 0)),
            const SizedBox(width: 10),
            Text("$percent%", style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.normal)),
          ],
        );
      },
    );
  }

  Widget _buildTotalQuestionWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Question", style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
          builder: (context, state) {
            if (state.data.questions != null && state.data.questions!.isNotEmpty) {
              return Text("${state.totalAnswered}/${state.data.questions?.length ?? 0} answered", style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.normal));
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildQuestionList(int moduleIndex) {
    return BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator(color: AppColors.whiteColor);
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.data.questions?.length ?? 0,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final data = state.data.questions![index];
            print("question data: ${data.islocked}");
            return Padding(
              padding: EdgeInsets.only(bottom: index == ((state.data.questions?.length ?? 0) - 1) ? 20 : 0),
              child: _QuestionCard(
                fromFriends: widget.fromFriends,
                data: data,
                index: index,
                moduleIndex: moduleIndex,
                onTap: () {
                  print("question data: click ${data.islocked}");
                  if ((data.islocked ?? false) == false) {
                    context.read<ListOfModuleCubit>().expandCard(index: index);
                  } else {
                    LockedQuestionDialog.show(context, title: "question");
                  }
                  // context.read<ListOfModuleCubit>().toggleQuestionelection(goal.goalIdPk);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionItems data;
  final VoidCallback onTap;
  final int index;
  final int moduleIndex;
  final bool fromFriends;

  const _QuestionCard({required this.data, required this.onTap, required this.index, required this.moduleIndex, required this.fromFriends, super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = (data.islocked ?? false) ? Utils.hexToColor(data.activecolorcode!) : Utils.hexToColor(data.deactivecolorcode!);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(data.isExpanded ? 0 : 16), topRight: const Radius.circular(16)),
              child: Lottie.asset(Utils.getModuleLottie(data.imagecode), height: 60, fit: BoxFit.cover),
            ),
          ),

          /// Animated expand/collapse
          Container(
            decoration: BoxDecoration(color: (data.islocked ?? false) ? AppColors.blackColor.withValues(alpha: 0.6) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
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
                        context.read<ListOfModuleCubit>().getExpandedCardData(questionId: data.questionidpK!, index: index);
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
                              (data.islocked ?? false)
                                  ? Image.asset(Images.ic_lock, height: 30, width: 30)
                                  : AnimatedRotation(turns: data.isExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 300), child: Image.asset(Images.ic_drop, height: 30, width: 30)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.width),
                            child: Text(
                              data.questiontitle ?? "",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.whiteColor, fontSize: 15, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              maxLines: data.isExpanded ? 5 : 1,
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
                    child: _buildStaticListContent(
                      moduleIndex: moduleIndex,
                      mIndex: index,
                      mContext: context,
                      qId: data.questionidpK!,
                      fromFriends: fromFriends,
                      questionText: data.questiondescription ?? "",
                    ),
                  ),
                  crossFadeState: data.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
  Widget _buildStaticListContent({required int moduleIndex, required int mIndex, required BuildContext mContext, required int qId, required bool fromFriends, required String questionText}) {
    return BlocBuilder<ListOfModuleCubit, ListOfModuleState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              itemCount: state.data.questions![mIndex].answers?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {

                return _buildListItem(qId: qId, moduleIndex: moduleIndex, parentIndex: mIndex, index: index, data: data.answers![index], icon: Icons.star, context: context, fromFriends: fromFriends);
              },
            ),
            const SizedBox(height: 20),
            Visibility(visible: !fromFriends, child: _buildAddMoreButtons(mContext, qId, mIndex, moduleIndex, questionText)),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildListItem({
    required int moduleIndex,
    required int qId,
    required int parentIndex,
    required int index,
    required ModuleAnswerData data,
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
            Visibility(visible: !fromFriends, child: _buildMenuPopUp(parentIndex, index, qId)),
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
                  : data.answerType == 1
                  ? const SizedBox.shrink()
                  : data.answerType == 4
                  ? GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ImagePreview(url: data.answerMedia ?? "")));
                    },
                    child: Hero(tag: data.answerMedia ?? "01010", child: AppNetworkImage(url: data.answerMedia ?? "")),
                  )
                  : CustomVideoPlayer(borderRadius: BorderRadius.circular(10), height: 200, width: double.infinity, url: data.answerMedia ?? "", autoPlay: false, showControls: true),
              if (data.answerText != null && data.answerText!.isNotEmpty) const SizedBox(height: 10),
              Text(data.answerText ?? "", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreButtons(BuildContext context, dynamic qId, int mIndex, int moduleIndex, String questionText) {
    return Row(
      children: [
        const SizedBox(width: 6),
        Expanded(
          child: CustomButton(
            onPressed: () async {
              final cubit = context.read<ListOfModuleCubit>();
              final result = await Navigator.pushNamed(context, RoutesName.ANSWER_SCREEN, arguments: {"qId": qId, "mIndex": mIndex, "questionText": questionText});
              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insight added successfully")));
                // cubit.getExpandedCardData(questionId: qId, index: mIndex);
              }
            },
            btnText: "Add new insight",
          ),
        ),
        const SizedBox(width: 10),
        CustomButtonRound(
          onPressed: () {
            context.read<FavoriteMemoriesCubit>().addFavQuestion(questionId: data.questionidpK, context: context);
          },
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18), child: Image.asset(Images.save_ic, height: 20, width: 20)),
        ),
      ],
    );
  }

  Widget _buildMenuPopUp(parentIndex, index, qId) {
    return PullDownButton(
      position: PullDownMenuPosition.automatic,
      itemBuilder:
          (context) => [
            PullDownMenuItem(onTap: () {}, title: "Edit", icon: CupertinoIcons.pencil),
            PullDownMenuItem(
              onTap: () {
                showImagePicker(context, parentIndex, qId);
              },
              title: "Add Photo",
              icon: CupertinoIcons.camera,
            ),
            PullDownMenuItem(
              onTap: () {
                context.read<ListOfModuleCubit>().deleteAnswerOfModule(answerId: data.answers![index].answerIdPK!, parentIndex: parentIndex, index: index);
              },
              title: "Delete",
              icon: CupertinoIcons.delete,
              iconColor: Colors.red,
              isDestructive: true,
            ),
          ],
      buttonBuilder: (context, showMenu) => CupertinoButton(onPressed: showMenu, padding: EdgeInsets.zero, child: Image.asset(Images.menu_black, height: 16, width: 16)),
    );
  }

  void showImagePicker(BuildContext context, int mIndex, int qId) {
    final ImagePicker _picker = ImagePicker();
    Utils.showPhotoDialog(
      context: context,
      onCameraPressed: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          File file = File(image.path);
          context.read<ListOfModuleCubit>().submitFinalAnswer(qId, context, mIndex, file);
        }
      },
      onGalleryPressed: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          File file = File(image.path);
          context.read<ListOfModuleCubit>().submitFinalAnswer(qId, context, mIndex, file);
        }
      },
    );
  }
}
