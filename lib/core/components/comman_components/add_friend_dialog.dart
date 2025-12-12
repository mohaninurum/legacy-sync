import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_text_field.dart';

import '../../images/images.dart';

class AddFriendDialog extends StatefulWidget {
  final Function? onOkayPressed;

  const AddFriendDialog({
    Key? key,
    this.onOkayPressed,
  }) : super(key: key);

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();


  

  static Future<void> show(
      BuildContext context, {
        Function? onOkayPressed,
      }) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        barrierDismissible: true,
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return AddFriendDialog(
            onOkayPressed:(value){
              if(onOkayPressed != null){
                onOkayPressed(value);
              }

            },
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // iOS-like scale and fade animation
          const curve = Curves.easeOutBack;

          // Scale animation
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          // Fade animation
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ));

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

}

class _AddFriendDialogState extends State<AddFriendDialog> {
  TextEditingController codeEditingController = TextEditingController();
  bool btnEnable = false;


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blur background
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          // Dialog content
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF25232f),
                borderRadius: BorderRadius.circular(25),

              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(height: 20),

                  // Title
                   Text(
                    'Enter your friend code',
                    style: TextTheme.of(context).bodyMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(hintText: "Enter a friend code", controller: codeEditingController,bgColor:const Color(0xFF25232f),radias:25, borderColor: const Color(0xff2e2e4a),onChanged: (value){
                    if(value != null && value.toString().isNotEmpty){
                      setState(() {
                        btnEnable = true;
                      });
                    }else{
                      btnEnable = false;
                    }
                  },),
                  const SizedBox(height: 5),


                  // Button
                  _buildDefaultButton(context,btnEnable,codeEditingController.text),
                  const  SizedBox(height: 5),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultButton(BuildContext context,bool btnEnable,String code) {
    return CustomButton(
      enable: btnEnable,
      onPressed: (){
        Navigator.of(context).pop();
        if(btnEnable){
          if(widget.onOkayPressed != null){
            widget.onOkayPressed!(code);
          }
        }

      },
      btnText: "Okay",
    );
  }
}