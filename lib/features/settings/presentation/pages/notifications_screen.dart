import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/features/settings/presentation/bloc/settings_bloc/settings_cubit.dart';
import 'package:legacy_sync/features/settings/presentation/bloc/settings_state/settings_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadNotificationSettings();
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
            child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildWarningBanner(), const SizedBox(height: 20), _buildNotificationOptions()])),
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          if (state.enableNotifications) {
            return const SizedBox.shrink();
          }
        }
        if (state is SettingsInitial) {
          if (state.enableNotifications) {
            return const SizedBox.shrink();
          }
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.purple.withOpacity(0.3), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.purple.withOpacity(0.5))),
          child: const Text("Notifications Are Disabled Please Enable Them In Settings", style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        );
      },
    );
  }

  Widget _buildNotificationOptions() {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        bool enableNotifications = false;
        bool newFeaturedPosts = false;
        bool allNewPosts = false;

        if (state is SettingsInitial) {
          enableNotifications = state.enableNotifications;
          newFeaturedPosts = state.newFeaturedPosts;
          allNewPosts = state.allNewPosts;
        } else if (state is SettingsLoaded) {
          enableNotifications = state.enableNotifications;
          newFeaturedPosts = state.newFeaturedPosts;
          allNewPosts = state.allNewPosts;
        }

        return Column(
          children: [
            _buildNotificationOption(
              title: "Enable Notifications",
              value: enableNotifications,
              onChanged: (value) {
                context.read<SettingsCubit>().updateNotificationSettings(enableNotifications: value);
              },
            ),
            const SizedBox(height: 16),
            _buildNotificationOption(
              title: "New Featured Posts",
              value: newFeaturedPosts,
              onChanged: (value) {
                context.read<SettingsCubit>().updateNotificationSettings(newFeaturedPosts: value);
              },
            ),
            const SizedBox(height: 16),
            _buildNotificationOption(
              title: "All New Posts",
              value: allNewPosts,
              onChanged: (value) {
                context.read<SettingsCubit>().updateNotificationSettings(allNewPosts: value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationOption({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: TextTheme.of(context).bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16))),

        CupertinoSwitch(value: value, onChanged: onChanged, activeTrackColor: AppColors.yellow, inactiveThumbColor: Colors.white, inactiveTrackColor: Colors.grey),
      ],
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Notifications");
  }
}
