import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/components/comman_components/user_image_widget.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_state/profile_state.dart';
import 'package:legacy_sync/features/profile/presentation/pages/profile_page.dart';
import 'package:legacy_sync/features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';
import '../../../../core/components/comman_components/gradient_divider_single.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildAppBar(),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildUserInfoWidget(),
                  const SizedBox(height: 30),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_user_svg,
                    tittle: "Account and profile",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.EDIT_PROFILE_SCREEN);
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_notification_svg,
                    tittle: "Notifications",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.NOTIFICATIONS_SCREEN,
                      );
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_suport_svg,
                    tittle: "Support",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.SUPPORT_SCREEN);
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_menu_svg,
                    tittle: "More",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.SETTING_MORE_OPTIONS_SCREEN,
                      );
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: "",
                    icon: Image.asset(Images.ic_google, height: 24, width: 24),
                    tittle: "legacysync.co",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("https://legacysync.io/");

                    },
                  ),

                  // _buildOptionWidget(
                  //   svgImagePath: "",
                  //   icon: Image.asset(Images.ic_google, height: 24, width: 24),
                  //   tittle: "Check Legacy Animations",
                  //   onTap: () {
                  //     Navigator.pushNamed(
                  //       context,
                  //       RoutesName.LEGACY_WRAPPED_SCREEN,
                  //     );
                  //   },
                  // ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_insta_svg,
                    tittle: "legacysync",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("https://www.instagram.com/legacysync.app/?igsh=MXB0aHBhNWJuMmJ0dA%3D%3D#");

                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_facebook_svg,
                    tittle: "legacysync",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("https://www.facebook.com/");

                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_tiktok_svg,
                    tittle: "legacysync",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("www.tiktok.com/@legacysync.app");

                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_x_svg,
                    tittle: "legacysync",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("https://x.com/LegacySyncApp");
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  _buildLogOutOptionWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const GradientDividerSingle();
  }

  Widget _buildOptionWidget({
    Widget? icon,
    required String svgImagePath,
    required String tittle,
    required VoidCallback onTap,
  }) {
    return AppButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SvgPicture.asset(svgImagePath, height: 24, width: 24),
          const SizedBox(width: 16),
          Text(
            tittle,
            style: TextTheme.of(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SvgPicture.asset(Images.ic_arrow_right, height: 24, width: 24),
        ],
      ),
    );
  }

  Widget _buildLogOutOptionWidget() {
    return AppButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: () {
        Utils.showLogOutDialog(
          context: context,
          title: "Logout Confirmation!",
          content: "Are you sure you want to logout from this device?",
          actionsText: "Logout",
          onPressed: (){
            AppPreference().clearAll();
            AppPreference().clearAllCachedQuestionData();
            Navigator.pushNamedAndRemoveUntil(context, RoutesName.SOCIAL_LOGIN_SCREEN, (Route<dynamic> route) => false);

          }
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Images.ic_log_out_svg, height: 24, width: 24),
          const SizedBox(width: 16),
          Text(
            "Log out",
            style: TextTheme.of(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.normal,
              color: const Color(0xFFFF0000),
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SvgPicture.asset(Images.ic_arrow_right, height: 24, width: 24),
        ],
      ),
    );
  }

  Widget _buildUserInfoWidget() {
    return BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) {
    return Row(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return UserImageWidget(assetPlaceholder: Images.image_user, size: 70, filePath: state.imageFilePath, imageUrl: state.profileData?.profileImage);
          },
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${state.profileData?.firstName??""} ${state.profileData?.lastName??""}",
              style: TextTheme.of(context).bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              state.profileData?.email??"",
              style: TextTheme.of(context).bodyMedium!.copyWith(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  },
);
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Settings");
  }
}
