import 'package:flutter/material.dart';

class SettingsItemModel {
  final String title;
  final IconData? icon;
  final String? iconPath;
  final VoidCallback? onTap;
  final bool showArrow;
  final SettingsItemType type;
  final Color? iconColor;

  SettingsItemModel({
    required this.title,
    this.icon,
    this.iconPath,
    this.onTap,
    this.showArrow = true,
    this.type = SettingsItemType.normal,
    this.iconColor,
  });
}

enum SettingsItemType { normal, social, logout, divider }

class UserProfileModel {
  final String name;
  final String email;
  final String? avatarUrl;

  UserProfileModel({required this.name, required this.email, this.avatarUrl});
}
