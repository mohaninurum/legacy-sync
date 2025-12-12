class ModuleAnswerModel {
  ModuleAnswerModel({
      this.status, 
      this.message, 
      this.data,});

  ModuleAnswerModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ModuleAnswerData.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ModuleAnswerData>? data;
ModuleAnswerModel copyWith({  String? status,
  String? message,
  List<ModuleAnswerData>? data,
}) => ModuleAnswerModel(  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
);
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

class ModuleAnswerData {
  ModuleAnswerData({
      this.answerIdPK, 
      this.questionIdFK, 
      this.userIdFK, 
      this.answerType, 
      this.answerText, 
      this.answerMedia, 
      this.createdAt, 
      this.updatedAt,});

  ModuleAnswerData.fromJson(dynamic json) {
    answerIdPK = json['answer_id_PK'];
    questionIdFK = json['question_id_FK'];
    userIdFK = json['user_id_FK'];
    answerType = json['answer_type'];
    answerText = json['answer_text'];
    answerMedia = json['answer_media'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? answerIdPK;
  int? questionIdFK;
  int? userIdFK;
  int? answerType;
  String? answerText;
  String? answerMedia;
  String? createdAt;
  dynamic updatedAt;
ModuleAnswerData copyWith({  int? answerIdPK,
  int? questionIdFK,
  int? userIdFK,
  int? answerType,
  dynamic answerText,
  String? answerMedia,
  String? createdAt,
  dynamic updatedAt,
}) => ModuleAnswerData(  answerIdPK: answerIdPK ?? this.answerIdPK,
  questionIdFK: questionIdFK ?? this.questionIdFK,
  userIdFK: userIdFK ?? this.userIdFK,
  answerType: answerType ?? this.answerType,
  answerText: answerText ?? this.answerText,
  answerMedia: answerMedia ?? this.answerMedia,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['answer_id_PK'] = answerIdPK;
    map['question_id_FK'] = questionIdFK;
    map['user_id_FK'] = userIdFK;
    map['answer_type'] = answerType;
    map['answer_text'] = answerText;
    map['answer_media'] = answerMedia;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}