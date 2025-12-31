import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import '../../config/routes/routes_name.dart';
import '../../core/components/comman_components/call_action_button.dart';
import '../../core/images/images.dart';


class IncomingCallFullScreen extends StatefulWidget {
  const IncomingCallFullScreen({super.key});

  @override
  State<IncomingCallFullScreen> createState() => _IncomingCallFullScreenState();
}

class _IncomingCallFullScreenState extends State<IncomingCallFullScreen> {



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.teal_accent_Color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 7.height,),
            SvgPicture.asset(Images.microphone, height: 40,width: 40,color: AppColors.blackColor,),
            SizedBox(height: 1.5.height,),
            Text(AppStrings.legacySync,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 1.5.height,),
            Text(AppStrings.invitedPodcast,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),),
            SizedBox( height: 40.height, child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(left:0,right: 0,top: 0, child: Image.asset(Images.user_you)),
                Positioned(left:0,right: 0,bottom: -75, child: Container(color: AppColors.teal_accent_Color, width: 300,height: 100,))
              ],
            ))

          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          actionCallButton(),
        ],
      ) ,
    );
  }

  Widget actionCallButton(){
   return  Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
     child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              CallActionButton(
                  enable: false,
                  onPressed: () {
            Navigator.pop(context);
              },
                  child: const Icon(Icons.close,color: AppColors.whiteColor,size: 30,)
                  ),
              SizedBox(height: 5,),
               Text("Decline",      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),)
            ],
          ),
          Column(
            children: [
              CallActionButton(
                  enable: true,
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.PODCAST_RECORDING_SCREEN,arguments: {
                      "incoming_call":true,
                      "userName":"naila"

                    });

              }, child:const Icon(Icons.done,color: AppColors.whiteColor,size: 30,) ),
               SizedBox(height: 5,),
               Text("Accept",      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
              ),)
            ],
          )


      ],),
   );
  }



}
