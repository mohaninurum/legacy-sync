

import '../../../../core/colors/colors.dart';
import '../../../podcast_recording/data/user_list_model/user_list_model.dart';
import '../../../podcast_recording/presentation/pages/widgets/audio_waves_widget.dart';
import 'package:flutter/material.dart';




Widget _userCard(UserListModel user,int index,int plusUser) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.gray_light,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.Border_Color, width: 4),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          height: 125,
          child: Stack(
            children: [
              user.avatar != null
                  ? Positioned(
                bottom: -20,
                left: 0,
                right: 0,
                child: Transform.scale(
                  scale: 1.5,
                  child: ClipOval(
                    child: Image.asset(user.avatar!, height: 125),
                  ),
                ),
              )
                  : Text(
                user.avatar ?? 'M',
                style: const TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        const Spacer(),
        Align(
          alignment: AlignmentGeometry.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              YouAudioWave(useName: user.name),
              // if(index==1&&plusUser>=3)
                // plushUser(plusUser),
            ],
          ),
        ),

      ],
    ),
  );
}