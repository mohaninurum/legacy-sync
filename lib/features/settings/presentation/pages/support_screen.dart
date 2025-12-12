import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/config/db/shared_preferences.dart';
import 'package:legacy_sync/core/utils/utils.dart' show Utils;
import 'package:legacy_sync/features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
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
                  _buildOptionWidget(
                    svgImagePath: Images.ic_report_svg,
                    tittle: "Report a bug",
                    onTap: () {
                      context.read<SettingsCubit>().openEmail();

                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_suport_svg,
                    tittle: "FAQ",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.FAQ_SCREEN);
                    },
                  ),
                  _buildOptionWidget(
                    svgImagePath: Images.ic_headphones_svg,
                    tittle: "Contact us",
                    onTap: () {
                      context.read<SettingsCubit>().openEmail();
                    },
                  ),
                  _buildDeleteAccountOptionWidget()

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDeleteAccountOptionWidget() {
    return AppButton(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: () {
        Utils.showLogOutDialog(
          context: context,
          title: "Account Confirmation!",
          content: "Are you sure you want to delete your account?",
          actionsText: "Delete",
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
          SvgPicture.asset(Images.ic_delete_svg, height: 24, width: 24),
          const SizedBox(width: 16),
          Text(
            "Delete Account",
            style: TextTheme.of(context).bodyMedium!.copyWith(
              fontWeight: FontWeight.normal,
              color: const Color(0xFFFF0000),
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SvgPicture.asset(Images.ic_arrow_right, height: 24, width: 24,color: Color(0xFFFF0000),),
        ],
      ),
    );
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

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Support");
  }
}
