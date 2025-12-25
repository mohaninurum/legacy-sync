import 'package:flutter/material.dart';
import 'package:legacy_sync/core/extension/extension.dart';

import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/curved_header_clipper.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../../../../core/images/images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/my_podcast_cubit.dart';
import '../bloc/my_podcast_state.dart';

class MyPodcastScreen extends StatefulWidget {
  const MyPodcastScreen({super.key});

  @override
  State<MyPodcastScreen> createState() => _MyPodcastScreenState();
}

class _MyPodcastScreenState extends State<MyPodcastScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyPodcastCubit>().loadTab("Posted");

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
                _tabs(),
                _list(),


              ],
            ),
          ),
        ),
      );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 26.5.height,
      width: double.infinity,
      child: Stack(
        children: [
          _buildBackButton(),
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
                ],
              ),
            ),
          ),

        ],
      ),
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





  Widget _tabs() => BlocBuilder<MyPodcastCubit, MyPodcastState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: ["Posted", "Draft", "Favorite"]
              .map(
                (tab) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child:ChoiceChip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: state.selectedTab == tab
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
                showCheckmark: false,

                // 🔑 IMPORTANT
                backgroundColor: AppColors.bg_container,
                selectedColor: AppColors.purple400,

                // label style control
                label: Text(
                  tab,
                  style: TextStyle(
                    color: state.selectedTab == tab
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                selected: state.selectedTab == tab,

                onSelected: (_) {
                  context.read<MyPodcastCubit>().loadTab(tab);
                },
              )
            ),
          )
              .toList(),
        ),
      );
    },
  );


  Widget _list() => BlocBuilder<MyPodcastCubit, MyPodcastState>(
    builder: (context, state) {
      if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.podcasts.isEmpty) {
        return const Center(
          child: Text(
            "No podcasts found",
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        itemCount: state.podcasts.length,
        itemBuilder: (_, i) {
          final p = state.podcasts[i];
          return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:Image.asset(p.image, width: 80, height: 80),
            ),
            title: Text(
              p.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
            ),
            subtitle: Text(
              p.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400 )
            ),
            trailing: Text(
              p.duration,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)
            ),
          );
        },
      );
    },
  );


}



