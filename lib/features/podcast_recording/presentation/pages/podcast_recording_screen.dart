import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/images/images.dart';
import '../../data/user_list_model/user_list_model.dart';
import '../bloc/podcast_recording_cubit.dart';
import '../bloc/podcast_recording_state.dart';


class PodcastRecordingScreen extends StatefulWidget {
  const PodcastRecordingScreen({super.key});

  @override
  State<PodcastRecordingScreen> createState() => _PodcastRecordingScreenState();
}
class _PodcastRecordingScreenState extends State<PodcastRecordingScreen> {

  @override
  void initState() {
    super.initState();
    context.read<PodCastRecordingCubit>().getInviteUse();
    context.read<PodCastRecordingCubit>().loadTopics();
    context.read<PodCastRecordingCubit>().addSelfParticipant();

  }


  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
            builder: (context, state) {
              return Column(
                children: [
                  _topHeader(state),
                  SizedBox(height: 1.height),
                  _topicCard(context,state),
                  SizedBox(height: 0.5.height),
                  _participantsGrid(state, context),
                  const Spacer(),
                  _recordingSection(state, context),
                  SizedBox(height: 1.height),
                  _bottomCallControls(),
                  SizedBox(height: 2.8.height),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topHeader(PodCastRecordingState state) {
    String title = "Recording Not Started Yet";
    Color color = Colors.white;

    if (state.status == PodCastRecordingStatus.recording) {
      title = "🔴 Now Recording";
      color = Colors.red;
    } else if (state.status == PodCastRecordingStatus.paused) {
      title = "⏸ Recording Paused";
      color = Colors.orange;
    } else if (state.status == PodCastRecordingStatus.completed) {
      title = "✅ Done Recording";
      color = Colors.green;
    }

    Widget _buildBackButton() {
      return AppButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      );
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          Column(
            children: [
              Text(title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text("You, Mom", style: TextStyle(color: Colors.white70)),
            ],
          ),
          SvgPicture.asset(Images.user_plus,width: 24,height: 24,)
        ],
      ),
    );
  }

  Widget _participantsGrid(PodCastRecordingState state, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: state.participants.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          if (i == state.participants.length) {
            return GestureDetector(
              onTap: (){
                // showInviteBottomSheet(context);
              },
              child: _inviteCard(),
            );
          }
          return _userCard(state.participants[i]);
        },
      ),
    );
  }

  Widget _recordingSection(PodCastRecordingState state, BuildContext context) {
    if (state.status == PodCastRecordingStatus.completed) {
      return _doneRecordingCard(state);
    }

    if (state.status == PodCastRecordingStatus.recording ||
        state.status == PodCastRecordingStatus.paused) {
      return Column(
        children: [
          _waveform(),
          const SizedBox(height: 8),
          Text(
             Utils.formatDuration(state.duration),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton(
                icon: state.status == PodCastRecordingStatus.paused
                    ? Icons.play_arrow
                    : Icons.pause,
                label: state.status == PodCastRecordingStatus.paused
                    ? "Resume Recording"
                    : "Pause Recording",
                onTap: () {
                  state.status == PodCastRecordingStatus.paused
                      ? context.read<PodCastRecordingCubit>().resumeRecording()
                      : context.read<PodCastRecordingCubit>().pauseRecording();
                },
              ),
              const SizedBox(width: 16),
              _actionButton(
                icon: Icons.stop,
                label: "Stop Recording",
                color: Colors.red,
                onTap: () {
                  context.read<PodCastRecordingCubit>().stopRecording();
                },
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        _recordButton(() {
          context.read<PodCastRecordingCubit>().startRecording();
        }),
        const SizedBox(height: 8),
        const Text("Record", style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _doneRecordingCard(PodCastRecordingState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Congratulations!",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "You've completed your podcast recording.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Recording Time: ${Utils.formatDuration(state.duration)}",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void showInviteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return BlocBuilder<PodCastRecordingCubit, PodCastRecordingState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.inviteUserList.length,
              itemBuilder: (_, i) {
                final user = state.inviteUserList[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(user.avatar??"Image")),
                  title: Text(user.name,
                      style: const TextStyle(color: Colors.white)),
                  trailing: TextButton(
                    onPressed: () {
                      context.read<PodCastRecordingCubit>().addParticipant(user);
                      Navigator.pop(context);
                    },
                    child: const Text("+ Invite"),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _waveform() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          24,
              (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 3,
            height: (i % 2 == 0) ? 28 : 16,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _recordButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFFF5A5F), Color(0xFFFF2D55)],
          ),

        ),
        child: const Icon(Icons.mic, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _userCard(UserListModel user) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:  AppColors.gray_light,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.Border_Color, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:AppColors.blackColor,
            backgroundImage:
            user.avatar != null ? AssetImage(user.avatar!) : null,
            child: user.avatar == null
                ? Text(
              user.initials,
              style: const TextStyle(fontSize: 22),
            )
                : null,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inviteCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dart_grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Images.user_plus,width: 32,height: 32,color:  AppColors.blackColor,),
          const SizedBox(height: 8),
          Text("Invite People",   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),),
        ],
      ),
    );
  }

  Widget _topicCard(BuildContext context, PodCastRecordingState state) {
    if (state.allTopics .isEmpty) return const SizedBox();

    final topic = state.allTopics[state.currentTopicIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlueDark,
            AppColors.primaryBlueDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TOP CHIPS
          Row(
            children: [
              const Text(
                "Topics :",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 8),

              /// SHUFFLE
              GestureDetector(
                onTap: () {
                  context.read<PodCastRecordingCubit>().shuffleTopics();
                },
                child: _topicChip(
                  icon: Icons.shuffle,
                  label: "Shuffle",
                  selected: state.shuffle,
                ),
              ),

              /// FAMILY
              GestureDetector(
                onTap: () {
                  context.read<PodCastRecordingCubit>()
                      .filterByCategory(TopicCategory.family);
                },
                child: _topicChip(
                  label: "Family",
                  selected:
                  state.selectedCategory == TopicCategory.family,
                ),
              ),

              /// RELATIONSHIP
              GestureDetector(
                onTap: () {
                  context.read<PodCastRecordingCubit>()
                      .filterByCategory(TopicCategory.relationship);
                },
                child: _topicChip(
                  label: "Relationship",
                  selected: state.selectedCategory ==
                      TopicCategory.relationship,
                ),
              ),
            ],
          ),


          const SizedBox(height: 16),

          /// 🔹 TOPIC TEXT
          Center(
            child: Text(
              topic.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// 🔹 ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: _nextAndPreButton(
                  label: "Previous",
                  enabled: state.currentTopicIndex > 0,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB0B0B0),
                      Color(0xFF8E8E8E),
                    ],
                  ),
                  onTap: () {
                    context
                        .read<PodCastRecordingCubit>()
                        .previousTopic();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _nextAndPreButton(
                  label: "Next",
                  enabled: state.currentTopicIndex <
                      state.allTopics.length - 1,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B7DFF),
                      Color(0xFFA59BFF),
                    ],
                  ),
                  onTap: () {
                    context
                        .read<PodCastRecordingCubit>()
                        .nextTopic();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _bottomCallControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleBtn(Icons.volume_up),
        _circleBtn(Icons.mic_off),
        _circleBtn(Icons.call_end, color: AppColors.redColor),
      ],
    );
  }

  Widget _circleBtn(IconData icon, {Color? color}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.grey.shade700,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    Color color = Colors.deepPurple,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }


  Widget _nextAndPreButton({
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: enabled
              ? gradient
              : LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled
                ? Colors.white
                : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  Widget _topicChip({
    IconData? icon,
    required String label,
    bool selected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withOpacity(0.25)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }


}
