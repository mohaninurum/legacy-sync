import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/podcast_bg.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_cubit/create_new_podcast_cubit.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_state/create_new_podcast_state.dart';
import '../../../../core/components/comman_components/custom_text_field.dart';

class CreateNewPodcastScreen extends StatefulWidget {
  const CreateNewPodcastScreen({super.key});

  @override
  State<CreateNewPodcastScreen> createState() => _CreateNewPodcastScreenState();
}

class _CreateNewPodcastScreenState extends State<CreateNewPodcastScreen> {
  final _scrollController = ScrollController();

  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();

  final _titleKey = GlobalKey();
  final _descKey = GlobalKey();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _titleFocus.addListener(() {
      if (_titleFocus.hasFocus) _scrollToKey(_titleKey);
    });

    _descFocus.addListener(() {
      if (_descFocus.hasFocus) _scrollToKey(_descKey);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    // Delay so keyboard is applied first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.2, // keep a bit of space above
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: BlocConsumer<CreateNewPodcastCubit, CreateNewPodcastState>(
        listenWhen: (prev, next) => prev.status != next.status,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.status == CreatePodcastStatus.success) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text("Podcast created successfully")),
              );

            // Navigate AFTER current frame to avoid context issues
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   Navigator.pushNamed(
            //     context,
            //     RoutesName.PODCAST_CONNECTION,
            //     arguments: {
            //       "roomId": state.roomId,
            //       "podcastId": state.podcastId,
            //       "incoming_call": false,
            //       "userName": state.userName,
            //       "userId": state.userId,
            //     },
            //   );
            // });
            // context.read<CreateNewPodcastCubit>().resetStatusToInitial();
          }

          if (state.status == CreatePodcastStatus.failure) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.generalError ?? "Something went wrong"),
                ),
              );
            context.read<CreateNewPodcastCubit>().resetStatusToInitial();
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: _bottomControls(context, state),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topHeader(context),
                          SizedBox(height: 2.height),
                          const SizedBox(height: 24),
                          Center(child: _coverPicker(context)),
                          const SizedBox(height: 24),
                          _sectionTitle("Title", context),
                          const SizedBox(height: 8),
                          Container(
                            key: _titleKey,
                            child: CustomTextField(
                              focusNode: _titleFocus,
                              bgColor: AppColors.bg_container,
                              hintText: "Add Title",
                              controller: _titleController,
                              keyboardType: TextInputType.text,
                              onChanged:
                                  (value) => context
                                      .read<CreateNewPodcastCubit>()
                                      .setTitle(value),
                            ),
                          ),
                          Visibility(
                            visible:
                                state.status == CreatePodcastStatus.failure &&
                                state.titleError == "Title is required",
                            child: Text(
                              state.titleError.toString(),
                              style: const TextStyle(color: AppColors.redColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _sectionTitle("Description", context),
                          const SizedBox(height: 8),
                          Container(
                            key: _descKey,
                            child: CustomTextField(
                              focusNode: _descFocus,
                              maxLines: 4,
                              bgColor: AppColors.bg_container,
                              hintText: "Add Description",
                              controller: _descController,
                              keyboardType: TextInputType.multiline,
                              onChanged:
                                  (value) => context
                                      .read<CreateNewPodcastCubit>()
                                      .setDescription(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomControls(BuildContext context, CreateNewPodcastState state) {
    final canSubmit = !state.isLoading && state.isFormValid;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
      child: SafeArea(
        top: false,
        child: CustomButton(
          isLoadingState: state.isLoading,
          enable: canSubmit,
          onPressed: () {
            canSubmit
                ? context.read<CreateNewPodcastCubit>().createPodcast()
                : null;
          },
          btnText: AppStrings.createNewPodcast,
          rightWidget: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _topHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _coverPicker(BuildContext context) {
    return BlocBuilder<CreateNewPodcastCubit, CreateNewPodcastState>(
      builder: (context, state) {
        final cubit = context.read<CreateNewPodcastCubit>();
        final path = state.coverImagePath;
        final hasImage =
            path != null && path.isNotEmpty && File(path).existsSync();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: cubit.pickCoverImage,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5E5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        state.status == CreatePodcastStatus.failure &&
                                state.coverError == "Please add cover image"
                            ? AppColors.redColor
                            : const Color(0xFFE5E5E5),
                  ),
                ),
                child:
                    !hasImage
                        ? const Icon(Icons.mic, size: 50, color: Colors.grey)
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(File(path!), fit: BoxFit.cover),
                        ),
              ),
            ),
            Visibility(
              visible:
                  state.status == CreatePodcastStatus.failure &&
                  state.coverError == "Please add cover image",
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    state.coverError.toString(),
                    style: const TextStyle(color: AppColors.redColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                cubit.pickCoverImage();
              },
              child: const Text(
                "Add Cover",
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
