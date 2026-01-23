import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/config/routes/routes.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button_common_mask_widgets.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/features/audio_preview_edit/presentation/widgets/audio_meta_widget.dart';

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
  final String audioPath;
  final PodcastModel? podcastModel;
  final bool isdraft;
  final String participants;


  const AudioPreviewEditScreen({super.key, required this.audioPath,this.podcastModel,required this.isdraft,required this.participants});

  @override
  State<AudioPreviewEditScreen> createState() => _AudioPreviewEditScreenState();
}

class _AudioPreviewEditScreenState extends State<AudioPreviewEditScreen> {
  @override
  void initState() {
    context.read<AudioPreviewEditCubit>().loadAudio(widget.audioPath,widget.isdraft);
    context.read<AudioPreviewEditCubit>().audioWavesLoad(widget.audioPath);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<AudioPreviewEditCubit, AudioPreviewEditState>(
            builder: (context, state) {
              final cubit = context.read<AudioPreviewEditCubit>();
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
                      audioPath: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
                    ),
                    AudioMetaWidget(state: state,participants: widget.participants,)
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: _bottomControls(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomButtonCommonMaskWidgets(
              isDisable: true,
              text: "Draft",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButtonCommonMaskWidgets(
              text: "Save",
              onTap: () async {
             // final path=   context.read<AudioPreviewEditCubit>().save(widget.audioPath,context);
             // debugPrint("Saved Audio => $path");
             //    Navigator.pop(context);
                Navigator.pushNamed(context, RoutesName.MY_PODCAST_SCREEN,arguments: {"isStartFirstTime":false});
              },
            ),

          ),
        ],
      ),
    );
  }

  Widget addCover(AudioPreviewEditState state) {
    return InkWell(
      onTap: () {
        final imagePicker = ImagePicker();
        imagePicker.pickImage(source: ImageSource.gallery).then((value) {
          context.read<AudioPreviewEditCubit>().addCover(value!.path);
        });
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
                      child: Image.file(
                        File(state.coverImage!),
                        fit: BoxFit.cover,
                        height: 160,
                        width: 160,
                      ),
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
}
