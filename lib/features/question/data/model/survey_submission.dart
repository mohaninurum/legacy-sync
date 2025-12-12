class SurveySubmission {
  final int userId;
  final List<SurveyAnswer> answers;

  SurveySubmission({required this.userId, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'SurveySubmission(userId: $userId, answers: $answers)';
  }
}

class SurveyAnswer {
  final int questionId;
  final int? optionId;
  final String? answerTextName;
  final String? answerTextAge;

  SurveyAnswer({
    required this.questionId,
    this.optionId,
    this.answerTextName,
    this.answerTextAge,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;

    if (optionId != null) {
      data['option_id'] = optionId;
    }
    if (answerTextName != null) {
      data['answer_text_name'] = answerTextName;
    }
    if (answerTextAge != null) {
      data['answer_text_age'] = answerTextAge;
    }

    return data;
  }

  @override
  String toString() {
    return 'SurveyAnswer(questionId: $questionId, optionId: $optionId, answerTextName: $answerTextName, answerTextAge: $answerTextAge)';
  }
}
