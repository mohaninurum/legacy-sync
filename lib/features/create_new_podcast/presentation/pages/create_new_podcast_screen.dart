import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/podcast_bg.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_cubit/create_new_podcast_cubit.dart';
import 'package:legacy_sync/features/create_new_podcast/presentation/bloc/create_new_podcast_state/create_new_podcast_state.dart';
import '../../../../core/components/comman_components/custom_text_field.dart';
import '../../../../core/strings/strings.dart';

class CreateNewPodcastScreen extends StatelessWidget {
  const CreateNewPodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      isDark: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocConsumer<CreateNewPodcastCubit, CreateNewPodcastState>(
            listener: (context, state) {
              if (state.status == CreatePodcastStatus.loading) {
                // show loader
              }

              if (state.status == CreatePodcastStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Podcast created successfully")),
                );
              }

              if (state.status == CreatePodcastStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? "Something went wrong")),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    coverPicker(context),
                    const SizedBox(height: 24),
                    sectionTitle("Title", context),
                    const SizedBox(height: 8),
                    _buildLoginForm(context, true),
                    const SizedBox(height: 6),
                    helperText(
                      "Auto-saved as Untitled Recording Oct 31, 2025",
                      context,
                    ),
                    const SizedBox(height: 20),
                    sectionTitle("Description", context),
                    const SizedBox(height: 8),
                    _buildLoginForm(context, false),
                    const SizedBox(height: 6),
                    helperText("Auto-saved using audio transcription", context),
                    const SizedBox(height: 24),
                    sectionTitle("Collaborator", context),
                    const SizedBox(height: 12),
                    collaboratorTile(context: context),
                    const SizedBox(height: 12),
                    const SizedBox(height: 28),
                    sectionTitle("Topics covered during recording", context),
                    const SizedBox(height: 12),
                    topicsRow(
                      topics: ["Relationship", "Friendship", "Work"],
                      context: context,
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: state.status == CreatePodcastStatus.loading
                          ? null
                          : () {
                        context.read<CreateNewPodcastCubit>().createPodcast();
                      },
                      child: state.status == CreatePodcastStatus.loading
                          ? const CircularProgressIndicator()
                          : const Text("Create Podcast"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget coverPicker(BuildContext context) {
    final cubit = context.read<CreateNewPodcastCubit>();

    return Column(
      children: [
        GestureDetector(
          onTap: cubit.pickCoverImage,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: cubit.coverImage == null
                ? const Icon(
              Icons.mic,
              size: 50,
              color: Colors.grey,
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                cubit.coverImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Add Cover",
          style: TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }


  Widget sectionTitle(String text, context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget helperText(String text, context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget collaboratorTile({context}) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/user_you.png",
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 12),
        // Text(name,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        //   fontSize: 16,
        //   fontWeight: FontWeight.w500,
        // ),),
      ],
    );
  }

  Widget topicsRow({required List<String> topics, context}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          topics.map((e) => topicChip(label: e, context: context)).toList(),
    );
  }

  Widget topicChip({required String label, context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFF9F8CFF)],
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool type) {
    return Column(
      children: [
        if (type)
          CustomTextField(
            bgColor: AppColors.bg_container,
            hintText: "Add Title",
            controller: context.read<CreateNewPodcastCubit>().title,
            keyboardType: TextInputType.text,
            onChanged: (value) {},
          )
        else
          CustomTextField(
            maxLines: 4,
            bgColor: AppColors.bg_container,
            hintText: "Add Description ",
            controller: context.read<CreateNewPodcastCubit>().description,
            keyboardType: TextInputType.multiline,
            onChanged: (value) {},
          ),
      ],
    );
  }
}
