import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'custom_button.dart';

Future<bool?> showCongratulationsDialog({required BuildContext context,userName,content,moduleName}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF25232f),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
         // contentPadding: EdgeInsets.zero, // Important for positioning
          child: Stack(
            children: [
              // Main Container Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: Colors.white,
                      size: 48,
                    ),

                    const SizedBox(height: 16),

                     Text(
                      "Congratulations, ${userName??''}!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                     Text(
                      content??'',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                        height: 2.0,
                      ),
                    ),

                    const SizedBox(height: 20),

                    moduleName!=null?   const Text(
                      "Ready to begin your next \n module?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ):const SizedBox.shrink(),
                    content==null?  const SizedBox(height: 20):const SizedBox.shrink(),
                    moduleName!=null?   Text(
                     moduleName??'',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                        height: 2.0,
                      ),
                    ):const SizedBox.shrink(),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        isMoudel: true,
                        btnText: "Begin",
                        rightWidget:const Text(""),

                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ✖ Close Button (Top Right)
              Positioned(
                right: 12,
                top: 12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



