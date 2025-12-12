import 'package:flutter/material.dart';

class LegacyJourneyStep {
  final String title;
  final String icon; // fallback emoji
  final String? iconAsset; // asset path for custom icons
  final bool isSvg; // whether iconAsset is SVG
  final bool isEnabled;
  final bool isCompleted;
  final Color backgroundColor;
  final Color borderColor;
  final String description;

  LegacyJourneyStep({
    required this.title,
    required this.icon,
    this.iconAsset,
    this.isSvg = false,
    required this.isEnabled,
    required this.isCompleted,
    required this.backgroundColor,
    required this.borderColor,
    required this.description,
  });

  LegacyJourneyStep copyWith({
    String? title,
    String? icon,
    String? iconAsset,
    bool? isSvg,
    bool? isEnabled,
    bool? isCompleted,
    Color? backgroundColor,
    Color? borderColor,
    String? description,
  }) {
    return LegacyJourneyStep(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      iconAsset: iconAsset ?? this.iconAsset,
      isSvg: isSvg ?? this.isSvg,
      isEnabled: isEnabled ?? this.isEnabled,
      isCompleted: isCompleted ?? this.isCompleted,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      description: description ?? this.description,
    );
  }
}

class UserProfile {
  final String name;
  final String avatar;
  final int completedSteps;
  final int totalSteps;

  UserProfile({
    required this.name,
    required this.avatar,
    required this.completedSteps,
    required this.totalSteps,
  });
}

class JourneyProgress {
  final int completedSteps;
  final int totalSteps;
  final String currentPhase;

  JourneyProgress({
    required this.completedSteps,
    required this.totalSteps,
    required this.currentPhase,
  });
}
