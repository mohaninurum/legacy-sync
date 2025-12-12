import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/curved_header_clipper.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_progress_bar_red_and_blak.dart';
import 'package:legacy_sync/core/components/comman_components/user_image_widget.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_bloc/card_cubit.dart';
import 'package:legacy_sync/features/card/presentation/bloc/card_state/card_state.dart';
import 'package:legacy_sync/features/profile/data/model/legacy_steps.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_state/profile_state.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/components/comman_components/gradient_divider_single_vertical.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile(context);
    context.read<CardCubit>().getCardDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),

          child: Column(
            children: [
              _buildBgStackImageAndOptions(),
              const SizedBox(height: 30),
              Image.asset(Images.fire_bols),
              const SizedBox(height: 30),
              SizedBox(width: 180, child: CustomButton(height: 40, onPressed: () {
                Navigator.pushNamed(context, RoutesName.CARD_SCREEN,arguments: {'hide_c_btn': true} );
              }, btnText: "View Legacy Card")),
              const SizedBox(height: 20),
              BlocBuilder<CardCubit, CardLoaded>(
  builder: (context, state) {
    return _buildMemoriesInfo(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Image.asset(Images.wallet_image, width: 50, height: 50),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text("${state.card.memoriesCaptured??0}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xfffab500), fontWeight: FontWeight.bold, fontSize: 32)),
                              Text("Memories\nCaptured", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xfffab500), fontWeight: FontWeight.normal, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                      GradientDividerSingleVertical(height: 100),
                      Row(
                        children: [
                          Image.asset(Images.video_blue, width: 50, height: 50),
                          const SizedBox(width: 10),
                          Column(
                            children: [
                              Text("${state.card.total_wisdom??0}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xff57ffc8), fontWeight: FontWeight.bold, fontSize: 32)),
                              Text("Total Wisdom\nVideo Hours", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0xff57ffc8), fontWeight: FontWeight.normal, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
  },
),
              // const SizedBox(height: 20),
              // _buildMemoriesInfo(
              //   children: [
              //     const SizedBox(height: 4),
              //     Text("Invite Your Friends", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: const Color(0xffcdcdcd))),
              //     const SizedBox(height: 20),
              //     Text("\$10 Per Friend Reffered", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              //     const SizedBox(height: 20),
              //     Image.asset(Images.share_button, height: 50, width: double.infinity),
              //     const SizedBox(height: 6),
              //   ],
              // ),
              const SizedBox(height: 20),

              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.steps == null || state.steps!.isEmpty) {
                    return const SizedBox();
                  }
                  return _buildListingWidget(state.steps!);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListingWidget(List<LegacySteps> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildListItem(data[index]);
        },
      ),
    );
  }

  Widget _buildListItem(LegacySteps data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset(data.imagePath, height: 32, width: 32),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.whiteColor, letterSpacing: 0, height: 1),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, color: const Color(0xffb5b3c1), fontWeight: FontWeight.normal, letterSpacing: 0, height: 1),
              ),
              const SizedBox(height: 10),
              // Text("${data.progress}"),
              GradientProgressBarReadAndBlackColor(currentStep:  data.progress,  totalSteps: 100, height: 6, startColor: const Color(0xff3353f4), endColor: const Color(0xff8d27f6)),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 30.5.height,
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
                  child: Lottie.asset(
                    LottieFiles.profile_header,
                    height: 25.height, // match parent height
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
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
                  Text("Profile", style: Theme.of(context).textTheme.bodyLarge),
                  AppButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.SETTINGS_SCREEN);
                    },
                    child: Text("Settings", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter,  child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return SizedBox(
                  height: 120,
                  width: 120,
                  child: UserImageWidget(assetPlaceholder: Images.image_user, size: 120,radius: 60, filePath: state.imageFilePath, imageUrl: state.profileData?.profileImage));
            },
          ),),
        ],
      ),
    );
  }

  Widget _buildMemoriesInfo({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: children),
    );
  }
}
