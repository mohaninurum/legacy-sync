class HomeJourneyCardModel {
  HomeJourneyCardModel({this.status, this.message, this.data});

  HomeJourneyCardModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(JourneyCardDataModel.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<JourneyCardDataModel>? data;

  HomeJourneyCardModel copyWith({bool? status, String? message, List<JourneyCardDataModel>? data}) =>
      HomeJourneyCardModel(status: status ?? this.status, message: message ?? this.message, data: data ?? this.data);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class JourneyCardDataModel {
  int? moduleIdPK;
  String? moduleTitle;
  String? moduleDescription;
  String? iconFileCode;
  String? colorCode;
  String? gradientColorCode;
  String? createdAt;
  dynamic updatedAt;
  bool? isLocked;

  JourneyCardDataModel({this.moduleIdPK, this.moduleTitle, this.moduleDescription, this.iconFileCode, this.colorCode, this.gradientColorCode, this.createdAt, this.updatedAt, this.isLocked});

  JourneyCardDataModel.fromJson(dynamic json) {
    moduleIdPK = json['module_id_PK'];
    moduleTitle = json['module_title'];
    moduleDescription = json['module_description'];
    iconFileCode = json['icon_file_code'];
    colorCode = json['color_code'];
    gradientColorCode = json['gradient_color_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isLocked = json['is_locked'];
  }

  JourneyCardDataModel copyWith({
    int? moduleIdPK,
    String? moduleTitle,
    String? moduleDescription,
    String? iconFileCode,
    String? colorCode,
    String? gradientColorCode,
    String? createdAt,
    dynamic updatedAt,
    bool? isLocked,
  }) => JourneyCardDataModel(
    moduleIdPK: moduleIdPK ?? this.moduleIdPK,
    moduleTitle: moduleTitle ?? this.moduleTitle,
    moduleDescription: moduleDescription ?? this.moduleDescription,
    iconFileCode: iconFileCode ?? this.iconFileCode,
    colorCode: colorCode ?? this.colorCode,
    gradientColorCode: gradientColorCode ?? this.gradientColorCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isLocked: isLocked ?? this.isLocked,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['module_id_PK'] = moduleIdPK;
    map['module_title'] = moduleTitle;
    map['module_description'] = moduleDescription;
    map['icon_file_code'] = iconFileCode;
    map['color_code'] = colorCode;
    map['gradient_color_code'] = gradientColorCode;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_locked'] = isLocked;
    return map;
  }
}
