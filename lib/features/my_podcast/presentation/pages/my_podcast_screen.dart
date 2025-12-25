import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';

import '../../../../config/routes/routes_name.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/components/comman_components/app_button.dart';
import '../../../../core/components/comman_components/common_add_fab.dart';
import '../../../../core/components/comman_components/curved_header_clipper.dart';
import '../../../../core/components/comman_components/podcast_bg.dart';
import '../../../../core/images/images.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../data/podcast_model.dart';
import '../../data/recent_user_list_model.dart';
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
    context.read<MyPodcastCubit>().allPodcastsContinueListening();
    context.read<MyPodcastCubit>().fetchRecentUserList();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildBgStackImageAndOptions(),
              SizedBox(height: 0.5.height),
              _header(AppStrings.continueListening, ''),
              SizedBox(height: 0.2.height),
              _listContinueListening(),
              _header(AppStrings.myPodcast, AppStrings.seeAll),
              SizedBox(height: 1.height),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _tabs(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: _list(),
              ),
              _header(AppStrings.recent, ""),
              SizedBox(height: 1.height),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: recentList(),
              ),
            ],
          ),
        ),
        floatingActionButton: CommonAddFab(
          size: 56,
          icon: Icons.add,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.PODCAST_RECORDING_SCREEN);
          },
        ),
      ),
    );
  }

  Widget _header(String title, String last) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: () {
              if (last == "See All") {
                context.read<MyPodcastCubit>().loadTab("all");
              }
            },
            child: Text(
              last,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.dart_grey,
              ),
            ),
          ),
        ],
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
                  child: Image.asset(
                    Images.pod_cast_img,
                    height: 25.height, // match parent height
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBackButton(),
                      Text(
                        "Podcast",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return AppButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
    );
  }

  Widget _tabs() => BlocBuilder<MyPodcastCubit, MyPodcastState>(
    builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children:
              ["Posted", "Draft", "Favorite"]
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                            color:
                                state.selectedTab == tab
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.4),
                          ),
                        ),
                        showCheckmark: false,
                        backgroundColor: AppColors.primaryColorDull,
                        selectedColor: AppColors.purple400,

                        // label style control
                        label: Text(
                          tab,
                          style: TextStyle(
                            color:
                                state.selectedTab == tab
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        selected: state.selectedTab == tab,

                        onSelected: (_) {
                          context.read<MyPodcastCubit>().loadTab(tab);
                        },
                      ),
                    ),
                  )
                  .toList(),
        ),
      );
    },
  );

  Widget _listContinueListening() =>
      BlocBuilder<MyPodcastCubit, MyPodcastState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.listPodcastsContinueListening.isEmpty) {
            return const Center(
              child: Text(
                "No podcasts found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return SizedBox(
            height: 120,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              itemCount: state.listPodcastsContinueListening.length,
              itemBuilder: (_, i) {
                final data = state.listPodcastsContinueListening[i];
                return SizedBox(width: 318, child: continueListening(data));
              },
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
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        itemCount: state.podcasts.length,
        itemBuilder: (_, i) {
          final data = state.podcasts[i];
          return myListPodcast(data, false);
        },
      );
    },
  );

  Widget continueListening(PodcastModel data) {
    final progress = context.read<MyPodcastCubit>().listeningProgress(
      data.listenedSec,
      data.totalDurationSec,
    );
    final timeLeftText = context.read<MyPodcastCubit>().timeLeftText(
      data.listenedSec,
      data.totalDurationSec,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              data.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 1.height),

                Row(
                  children: [
                    Text(
                      "Me  ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dart_grey,
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.dart_grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    Text(
                      "  ${Utils.capitalize(data.relationship)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dart_grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.purple400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeLeftText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myListPodcast(PodcastModel data, bool isContinueListening) {
    double progress = 0.0;
    String timeLeftText = "";
    if (isContinueListening) {
      progress = context.read<MyPodcastCubit>().listeningProgress(
        data.listenedSec,
        data.totalDurationSec,
      );
      timeLeftText = context.read<MyPodcastCubit>().timeLeftText(
        data.listenedSec,
        data.totalDurationSec,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              data.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT COLUMN (TOP aligned – as you want)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                isContinueListening
                    ? const SizedBox.shrink()
                    : SizedBox(height: 1.height),
                isContinueListening
                    ? const SizedBox.shrink()
                    : Text(
                      data.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                isContinueListening
                    ? SizedBox(height: 1.height)
                    : SizedBox(height: 1.height),
                Row(
                  children: [
                    Text(
                      "Me  ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dart_grey,
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.dart_grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    Text(
                      "  ${Utils.capitalize(data.relationship)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dart_grey,
                      ),
                    ),
                  ],
                ),
                isContinueListening
                    ? SizedBox(height: 1.5.height)
                    : SizedBox(height: 1.height),
                isContinueListening
                    ? Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress ?? 0,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade800,
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFB388FF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeLeftText,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                    : SizedBox(height: 1.height),
              ],
            ),
          ),
          isContinueListening
              ? const SizedBox.shrink()
              : SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    data.duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget recentPodcastUserList(RecentUserListModel data, ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              data.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 5),

          /// TEXT COLUMN (TOP aligned – as you want)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    Utils.capitalize(data.relationship),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color:data.type ==CallType.Missed?AppColors.redColor:Colors.white ,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SvgPicture.asset(Images.phone_incoming, height: 12,width: 12),
                   const SizedBox(width: 5,),
                    Text(
                      data.type ==CallType.Missed? CallType.Missed.name: data.duration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dart_grey,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    Utils.timeAgo(DateTime.parse(data.date))  ,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }


  Widget recentList() => BlocBuilder<MyPodcastCubit, MyPodcastState>(
    builder: (context, state) {
      if (state.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state.podcasts.isEmpty) {
        return const Center(
          child: Text(
            "No Data found",
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        itemCount: state.recentUserList .length,
        itemBuilder: (_, i) {
          final data = state.recentUserList[i];
          return recentPodcastUserList(data);
        },
      );
    },
  );

}
