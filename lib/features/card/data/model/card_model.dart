import 'package:flutter/material.dart';

class CardModel {
  final String? id;
  final String? title;
  final String? subtitle;
  final int? wisdomStreak;
  final int? total_wisdom;
  final int? memoriesCaptured;
  final String? legacyStartDate;
  final int? selectedGradientIndex;
  final List<Color>? gradientColors;

  CardModel({this.id, this.title, this.subtitle, this.wisdomStreak, this.memoriesCaptured, this.legacyStartDate, this.selectedGradientIndex, this.gradientColors, this.total_wisdom});

  factory CardModel.empty() => CardModel(id: '', title: '', subtitle: '', wisdomStreak: 0,total_wisdom: 0, memoriesCaptured: 0, legacyStartDate: '', selectedGradientIndex: 0, gradientColors: const []);

  CardModel copyWith({String? id, String? title, String? subtitle, int? wisdomStreak, int? memoriesCaptured,int? total_wisdom, String? legacyStartDate, int? selectedGradientIndex, List<Color>? gradientColors}) {
    return CardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      total_wisdom: total_wisdom ?? this.total_wisdom,
      wisdomStreak: wisdomStreak ?? this.wisdomStreak,
      memoriesCaptured: memoriesCaptured ?? this.memoriesCaptured,
      legacyStartDate: legacyStartDate ?? this.legacyStartDate,
      selectedGradientIndex: selectedGradientIndex ?? this.selectedGradientIndex,
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'wisdomStreak': wisdomStreak,
      'memoriesCaptured': memoriesCaptured,
      'legacyStartDate': legacyStartDate,
      'selectedGradientIndex': selectedGradientIndex,
      'total_wisdom': total_wisdom,
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      wisdomStreak: json['wisdomStreak'],
      memoriesCaptured: json['memoriesCaptured'],
      legacyStartDate: json['legacyStartDate'],
      selectedGradientIndex: json['selectedGradientIndex'],
      total_wisdom: json['total_wisdom'],
    );
  }
}

class GradientOption {
  final int index;
  final List<Color> colors;
  final String name;

  GradientOption({required this.index, required this.colors, required this.name});
}
