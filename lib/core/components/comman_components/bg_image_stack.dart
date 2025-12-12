import 'package:flutter/material.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class BgImageStack extends StatelessWidget {
  String imagePath;
  Widget child;
  BgImageStack({super.key, required this.child, this.imagePath = ""});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.blackColor,
          width: double.infinity,
          height: double.infinity,
          child:imagePath.contains(".json")? Lottie.asset(
            imagePath.isNotEmpty ? imagePath : Images.bg_image_star,
            fit: BoxFit.fill,
          ): Image.asset(
            imagePath.isNotEmpty ? imagePath : Images.bg_image_star,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: double.infinity, width: double.infinity, child: child),
      ],
    );
  }
}
