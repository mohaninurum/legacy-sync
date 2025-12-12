class SurveyQuestionsSubmitResponse {
  SurveyQuestionsSubmitResponse({
      this.status, 
      this.message,});

  SurveyQuestionsSubmitResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  bool? status;
  String? message;
SurveyQuestionsSubmitResponse copyWith({  bool? status,
  String? message,
}) => SurveyQuestionsSubmitResponse(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}