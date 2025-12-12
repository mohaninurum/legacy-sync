class SubmitAnswerResponse {
  final String? status;
  final String? message;
  final AnswerData? data;

  SubmitAnswerResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SubmitAnswerResponse.fromJson(Map<String, dynamic> json) {
    return SubmitAnswerResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AnswerData.fromJson(json['data'])
          : null,
    );
  }
}

class AnswerData {
  final int? answerId;
  final String? questionId;
  final String? userId;
  final String? answerType;
  final String? answerText;
  final String? answerMedia;
  final String? congratulationText;
  final String? nextModuleTitle;
  final bool? showCongratulation;

  AnswerData({
    this.answerId,
    this.questionId,
    this.userId,
    this.answerType,
    this.answerText,
    this.congratulationText,
    this.nextModuleTitle,
    this.answerMedia,
    this.showCongratulation,
  });

  factory AnswerData.fromJson(Map<String, dynamic> json) {
    return AnswerData(
      answerId: json['answer_id'] is int
          ? json['answer_id']
          : int.tryParse(json['answer_id'].toString()),
      questionId: json['question_id']?.toString(),
      userId: json['user_id']?.toString(),
      answerType: json['answer_type']?.toString(),
      answerText: json['answer_text']?.toString(),
      answerMedia: json['answer_media'], // null allowed
      showCongratulation: json['show_congratulation'] ?? false,
      congratulationText: json['congratulation_text']?.toString(),
      nextModuleTitle: json['next_module_title']?.toString(),
    );
  }
}
