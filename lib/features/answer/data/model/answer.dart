class AnswerModel {
  bool? status;
  String? message;
  List<AnswerData>? data;

  AnswerModel({this.status, this.message, this.data});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data =
        json["data"] == null
            ? null
            : (json["data"] as List)
                .map((e) => AnswerData.fromJson(e))
                .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["data"] = this.data?.map((e) => e.toJson()).toList();
    return data;
  }

  AnswerModel copyWith({
    bool? status,
    String? message,
    List<AnswerData>? data,
  }) => AnswerModel(
    status: status ?? this.status,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  // Initial fallback data when server fetch fails
  static AnswerModel getInitialData() {
    return AnswerModel(
      status: true,
      message: "Answers retrieved successfully.",
      data: [
        AnswerData(
          answerIdPk: 1,
          questionId: 1,
          answerText: "Pass on life stories and memories",
          answerCode: "a1o1",
          isSelected: false,
        ),
        AnswerData(
          answerIdPk: 2,
          questionId: 1,
          answerText: "Share wisdom and life lessons",
          answerCode: "a1o2",
          isSelected: false,
        ),
        AnswerData(
          answerIdPk: 3,
          questionId: 1,
          answerText: "Document family history and traditions",
          answerCode: "a1o3",
          isSelected: false,
        ),
        AnswerData(
          answerIdPk: 4,
          questionId: 1,
          answerText: "Leave behind my core values and beliefs",
          answerCode: "a1o4",
          isSelected: false,
        ),
      ],
    );
  }
}

class AnswerData {
  int answerIdPk;
  int questionId;
  String answerText;
  String answerCode;
  bool isSelected;

  AnswerData({
    required this.answerIdPk,
    required this.questionId,
    required this.answerText,
    required this.answerCode,
    this.isSelected = false,
  });

  AnswerData.fromJson(Map<String, dynamic> json)
    : answerIdPk = json["answer_id_PK"] ?? 0,
      questionId = json["question_id_FK"] ?? 0,
      answerText = json["answer_text"] ?? "",
      answerCode = json["answer_code"] ?? "",
      isSelected = false;

  Map<String, dynamic> toJson() {
    return {
      "answer_id_PK": answerIdPk,
      "question_id_FK": questionId,
      "answer_text": answerText,
      "answer_code": answerCode,
    };
  }

  AnswerData copyWith({
    int? answerIdPk,
    int? questionId,
    String? answerText,
    String? answerCode,
    bool? isSelected,
  }) {
    return AnswerData(
      answerIdPk: answerIdPk ?? this.answerIdPk,
      questionId: questionId ?? this.questionId,
      answerText: answerText ?? this.answerText,
      answerCode: answerCode ?? this.answerCode,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
