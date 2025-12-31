import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/images/images.dart';

class  ShowSuccessDialog {

  static void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            width: 300,
            height: 250,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F2E), // dark card
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle with check icon
                SizedBox(
                  height: 150,
                  width: 150,
                  child: SvgPicture.asset(Images.done,)
                ),





              ],
            ),
          ),
        );
      },
    );
  }

}