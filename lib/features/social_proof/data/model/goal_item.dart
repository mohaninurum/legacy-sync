class GoalResponse {
  final bool status;
  final String message;
  final List<GoalItem> data;

  GoalResponse({required this.status, required this.message, required this.data});

  factory GoalResponse.fromJson(Map<String, dynamic> json) {
    return GoalResponse(status: json['status'] as bool, message: json['message'] as String, data: (json['data'] as List<dynamic>).map((e) => GoalItem.fromJson(e as Map<String, dynamic>)).toList());
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.map((e) => e.toJson()).toList()};
  }
}

class GoalItem {
  final int goalIdPk;
  final String goalTitle;
  final String inactiveBgColorCode;
  final String activateBgColor;
  final String iconCode;
  final String iconColorCode;
  bool isSelected;

  GoalItem({
    required this.goalIdPk,
    required this.goalTitle,
    required this.inactiveBgColorCode,
    required this.activateBgColor,
    required this.iconCode,
    required this.iconColorCode,
    this.isSelected = false,
  });

  GoalItem copyWith({int? goalIdPk, String? goalTitle, String? inactiveBgColorCode, String? activateBgColor, String? iconCode, String? iconColorCode, bool? isSelected}) {
    return GoalItem(
      goalIdPk: goalIdPk ?? this.goalIdPk,
      goalTitle: goalTitle ?? this.goalTitle,
      inactiveBgColorCode: inactiveBgColorCode ?? this.inactiveBgColorCode,
      activateBgColor: activateBgColor ?? this.activateBgColor,
      iconCode: iconCode ?? this.iconCode,
      iconColorCode: iconColorCode ?? this.iconColorCode,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id_PK': goalIdPk,
      'goal_title': goalTitle,
      'inactive_bg_color_code': inactiveBgColorCode,
      'activate_bg_color': activateBgColor,
      'icon_code': iconCode,
      'icon_color_code': iconColorCode,
    };
  }

  factory GoalItem.fromJson(Map<String, dynamic> json) {
    return GoalItem(
      goalIdPk: json['goal_id_PK'] ?? 0,
      goalTitle: json['goal_title'] ?? '',
      inactiveBgColorCode: json['inactive_bg_color_code'] ?? '',
      activateBgColor: json['activate_bg_color'] ?? '',
      iconCode: json['icon_code'] ?? '',
      iconColorCode: json['icon_color_code'] ?? '',
    );
  }
}
