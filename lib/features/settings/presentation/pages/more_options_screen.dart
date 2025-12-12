import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';

class MoreOptionsScreen extends StatefulWidget {
  const MoreOptionsScreen({super.key});

  @override
  State<MoreOptionsScreen> createState() => _MoreOptionsScreenState();
}

class _MoreOptionsScreenState extends State<MoreOptionsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildOptionWidget(
                    svgImagePath: Images.ic_star_svg,
                    tittle: "Rate legacysync",
                    onTap: () {
                      context.read<SettingsCubit>().requestReview();
                      //Utils.showInfoDialog(context: context, title: "Coming Soon!");
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_replay_svg,
                    tittle: "Replay Tour",
                    onTap: () {
                      Utils.showInfoDialog(context: context, title: "Coming Soon!");
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_message_svg,
                    tittle: "Suggest a change or feature",
                    onTap: () {
                      Utils.showInfoDialog(context: context, title: "Coming Soon!");
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_terms_svg,
                    tittle: "Terms of use",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("http://139.59.57.87:5000/terms.html");
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_supscription_svg,
                    tittle: "Subscription details",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("http://139.59.57.87:5000/subscription.html");
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_privacy_svg,
                    tittle: "Privacy policy",
                    onTap: () {
                      context.read<SettingsCubit>().mLaunchUrl("http://139.59.57.87:5000/privacy.html");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionWidget({Widget? icon, required String svgImagePath, required String tittle, required VoidCallback onTap}) {
    return AppButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SvgPicture.asset(svgImagePath, height: 24, width: 24),
          const SizedBox(width: 16),
          Text(tittle, style: TextTheme.of(context).bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis),
          const Spacer(),
          SvgPicture.asset(Images.ic_arrow_right, height: 24, width: 24),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "More");
  }
}
