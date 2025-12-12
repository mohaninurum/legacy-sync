class DeleteAnswerModel {
  DeleteAnswerModel({
      this.status, 
      this.message,});

  DeleteAnswerModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
DeleteAnswerModel copyWith({  String? status,
  String? message,
}) => DeleteAnswerModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}