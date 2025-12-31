import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';

import '../../../../core/components/comman_components/custom_text_field.dart';
import '../../../../core/strings/strings.dart';
import '../bloc/audio_preview_edit_cubit.dart';
import '../bloc/audio_preview_edit_state.dart';

class AudioMetaWidget extends StatelessWidget {
  final AudioPreviewEditState state;
   AudioMetaWidget({super.key, required this.state});





  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          _SectionTitle("Title",context),
          const SizedBox(height: 8),
          _buildLoginForm(context,true),
          const SizedBox(height: 6),
          _HelperText("Auto-saved as Untitled Recording Oct 31, 2025",context),

          const SizedBox(height: 20),

          _SectionTitle("Description",context),
          const SizedBox(height: 8),
          _buildLoginForm(context,false),
          const SizedBox(height: 6),
          _HelperText("Auto-saved using audio transcription",context),

          const SizedBox(height: 24),

          _SectionTitle("Collaborator",context),
          const SizedBox(height: 12),
          _CollaboratorTile(name: "Mom",context: context),
          const SizedBox(height: 12),

          const SizedBox(height: 28),

          _SectionTitle("Topics covered during recording",context),
          const SizedBox(height: 12),
          _TopicsRow(topics: ["Relationship", "Friendship", "Work"],context: context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _SectionTitle(String text,context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _HelperText(String text,context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _CollaboratorTile({required String name,context}) {
    return Row(
      children: [
        ClipOval(
         child: Image.asset("assets/images/user_you.png",width: 50,height: 50,),
        ),
        const SizedBox(width: 12),
        Text(name,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    ),),
      ],
    );
  }

  Widget _TopicsRow({required List<String> topics,context}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: topics.map((e) => _TopicChip(label: e,context: context)).toList(),
    );
  }

  Widget _TopicChip({required String label,context}) {
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

  Widget _buildLoginForm(BuildContext context,bool type) {
    return Column(
      children: [
        if(type)
        CustomTextField(
          bgColor: AppColors.bg_container,
          hintText: "Add Title",
          controller:  context.read<AudioPreviewEditCubit>().title,
          keyboardType: TextInputType.text,
          onChanged: (value) {
          },
        )
     else
        CustomTextField(
          maxLines: 4,
          bgColor: AppColors.bg_container,
          hintText: "Add Description ",
          controller:  context.read<AudioPreviewEditCubit>().description,
          keyboardType: TextInputType.multiline,
          onChanged: (value) {

          },
        ),
      ],
    );
  }
}
