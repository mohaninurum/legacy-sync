class ListOfFavQueModelData {
  ListOfFavQueModelData({
      this.status, 
      this.data,});

  ListOfFavQueModelData.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FavoriteModelData.fromJson(v));
      });
    }
  }
  bool? status;
  List<FavoriteModelData>? data;
ListOfFavQueModelData copyWith({  bool? status,
  List<FavoriteModelData>? data,
}) => ListOfFavQueModelData(  status: status ?? this.status,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class FavoriteModelData {
  FavoriteModelData({
      this.questionTitle, 
      this.questionDescription, 
      this.activeColorCode, 
      this.deactiveColorCode, 
      this.imageCode, 
      this.moduleId, 
      this.moduleIcon, 
      this.moduleColor, 
      this.moduleTitle, 
      this.isExpanded,
    this.isHeader = false,

    this.answers,});

  FavoriteModelData.fromJson(dynamic json) {
    questionTitle = json['question_title'];
    questionDescription = json['question_description'];
    activeColorCode = json['active_color_code'];
    deactiveColorCode = json['deactive_color_code'];
    imageCode = json['image_code'];
    moduleId = json['module_id'];
    isExpanded = json['isExpanded'] ?? false;
    isHeader = json['isHeader'] ?? false;
    moduleIcon = json['module_icon'];
    moduleColor = json['module_color'];
    moduleTitle = json['module_title'];
    if (json['answers'] != null) {
      answers = [];
      json['answers'].forEach((v) {
        answers?.add(Answers.fromJson(v));
      });
    }
  }
  String? questionTitle;
  String? questionDescription;
  String? activeColorCode;
  String? deactiveColorCode;
  String? imageCode;
  int? moduleId;
  String? moduleIcon;
  String? moduleColor;
  String? moduleTitle;
  bool? isExpanded;
  bool? isHeader;
  List<Answers>? answers;
  FavoriteModelData copyWith({  String? questionTitle,
  String? questionDescription,
  String? activeColorCode,
  String? deactiveColorCode,
  String? imageCode,
  int? moduleId,
  String? moduleIcon,
  String? moduleColor,
  String? moduleTitle,
  bool? isExpanded,
  bool? isHeader,
  List<Answers>? answers,
}) => FavoriteModelData(  questionTitle: questionTitle ?? this.questionTitle,
  questionDescription: questionDescription ?? this.questionDescription,
  activeColorCode: activeColorCode ?? this.activeColorCode,
  deactiveColorCode: deactiveColorCode ?? this.deactiveColorCode,
  imageCode: imageCode ?? this.imageCode,
  moduleId: moduleId ?? this.moduleId,
  moduleIcon: moduleIcon ?? this.moduleIcon,
  moduleColor: moduleColor ?? this.moduleColor,
  moduleTitle: moduleTitle ?? this.moduleTitle,
  answers: answers ?? this.answers,
    isExpanded: isExpanded ?? this.isExpanded,
    isHeader: isHeader ?? this.isHeader,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_title'] = questionTitle;
    map['question_description'] = questionDescription;
    map['active_color_code'] = activeColorCode;
    map['deactive_color_code'] = deactiveColorCode;
    map['image_code'] = imageCode;
    map['module_id'] = moduleId;
    map['module_icon'] = moduleIcon;
    map['module_color'] = moduleColor;
    map['module_title'] = moduleTitle;
    map['isExpanded'] = isExpanded;
    map['isHeader'] = isHeader;
    if (answers != null) {
      map['answers'] = answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Answers {
  Answers({
      this.answerIdPK, 
      this.answerType, 
      this.answerText, 
      this.answerMedia, 
      this.createdAt, 
      this.updatedAt,});

  Answers.fromJson(dynamic json) {
    answerIdPK = json['answer_id_PK'];
    answerType = json['answer_type'];
    answerText = json['answer_text'];
    answerMedia = json['answer_media'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? answerIdPK;
  int? answerType;
  dynamic answerText;
  String? answerMedia;
  String? createdAt;
  dynamic updatedAt;
Answers copyWith({  int? answerIdPK,
  int? answerType,
  dynamic answerText,
  String? answerMedia,
  String? createdAt,
  dynamic updatedAt,
}) => Answers(  answerIdPK: answerIdPK ?? this.answerIdPK,
  answerType: answerType ?? this.answerType,
  answerText: answerText ?? this.answerText,
  answerMedia: answerMedia ?? this.answerMedia,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['answer_id_PK'] = answerIdPK;
    map['answer_type'] = answerType;
    map['answer_text'] = answerText;
    map['answer_media'] = answerMedia;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}