import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/curved_header_clipper.dart';
import '../../../../core/components/comman_components/custom_button.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../bloc/podcast_cubit.dart';
import '../bloc/podcast_state.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PodcastCubit>().fetchBuildOnwPodcast();

  }

  @override
  Widget build(BuildContext context) {
    return
      PodcastBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildBgStackImageAndOptions(),
              _buildCardInfo(),


          ],
          ),
        ),
      ),
     );
  }



  Widget _podcastjoin(){
    return   BlocBuilder<PodcastCubit, PodcastState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.PODCAST_CONNECTION);
          },
          child:  Text("Create Podcast",style: Theme.of(context).textTheme.bodyLarge),
        );
      },
    );
  }


  Widget _buildBackButton() {
    return  AppButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {

       Navigator.pop(context);

      },
      child:  const Icon(Icons.arrow_back_ios_rounded, color:Colors.white),
    );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 26.5.height,
      width: double.infinity,
      child: Stack(
        children: [

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipPath(
                clipper: CurvedHeaderClipper(),
                child: SizedBox(
                  height: 25.height,
                  child: Image.asset(Images.pod_cast_img,
                    height: 25.height, // match parent height
                      width: double.infinity,
                      fit: BoxFit.fill,
                  )
                  // Lottie.asset(
                  //   LottieFiles.pod_cast,
                  //   height: 25.height, // match parent height
                  //   width: double.infinity,
                  //   fit: BoxFit.fill,
                  // ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 60,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(mainAxisSize: MainAxisSize.min, children: [  _buildBackButton(),
                  Text("Podcast", style: Theme.of(context).textTheme.bodyLarge),],),
                  _podcastjoin(),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }



  Widget _buildCardInfo() {
    return Container(
      width: 363.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color:   AppColors.primaryBlueDark.withOpacity(0.25), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _firstPartCartText(),
        SizedBox(height: 2.height),
        _SecondPartCartText(),
        SizedBox(height: 2.5.height),
        _buildStartMakingPodcastButton(context),
        SizedBox(height: 0.5.height),
      ],),
    );
  }


  Widget _firstPartCartText(){
    return Center(
      child: Column(
        children: [
          SizedBox(height: 1.height),
          SvgPicture.asset(Images.microphone, height: 40,width: 40),
          SizedBox(height: 2.height),
          Text(AppStrings.podcastJourney, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20)),
          SizedBox(height: 2.height),
          Text(AppStrings.meaningfulStories, style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center,),

        ],
      ),
    );
  }

  Widget _SecondPartCartText(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.height),
        Text(AppStrings.buildOwnPodcast, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
       BlocBuilder<PodcastCubit, PodcastState>(
         builder: (context, state) {
           return state.isLoading?
            Center(child: CircularProgressIndicator(color:AppColors.bg_container.withOpacity(0.5) ,),)
        : ListView.builder(
             shrinkWrap: true,
          padding: const EdgeInsets.only(top: 10),
          physics: const NeverScrollableScrollPhysics(),
          itemCount:state.buildOwnPodcastList.length ,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              minTileHeight: 2.height,
              minVerticalPadding: 10,
              dense: true,
              title: Text(state.buildOwnPodcastList[index].title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text(state.buildOwnPodcastList[index].subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                 style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400 )
              ),
              leading: Image.asset(state.buildOwnPodcastList[index].image,height: 40,width: 40,),
              onTap: () {}
            );
          }
           );
         },
       )
      ],
    );
  }

  Widget _buildStartMakingPodcastButton(BuildContext context) {
    return CustomButton(
      height: 48,
      onPressed: () {
        Navigator.pushNamed(context, RoutesName.MY_PODCAST_SCREEN);
      },
      // isLoadingState: state.isLoading,
      // enable: state.isFormValid,
      btnText: AppStrings.startMakingPodcast,
    );
  }



}


