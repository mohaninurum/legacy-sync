import 'module_answer_model.dart';

class ListOfModuleModel {
  bool? status;
  String? message;
  QuestionData? data;

  ListOfModuleModel({this.status, this.message, this.data});

  ListOfModuleModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : QuestionData.fromJson(json["data"]);
  }
  factory ListOfModuleModel.empty() => ListOfModuleModel(status: false, message: '', data: QuestionData.empty());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["data"] = data;

    return data;
  }
  ListOfModuleModel copyWith({
    bool? status,
    String? message,
    QuestionData? data,
  }) {
    return ListOfModuleModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class QuestionData {
  String? screentitle;
  String? screendescription;
  String? moduleicon;
  String? modulecolor;
  int? progress;
  List<QuestionItems>? questions;

  QuestionData({this.screentitle, this.screendescription, this.moduleicon, this.modulecolor, this.progress, this.questions});
  factory QuestionData.empty() => QuestionData(screentitle: '', screendescription: '', moduleicon: '', modulecolor: '', progress: 0, questions: const []);

  QuestionData.fromJson(Map<String, dynamic> json) {
    screentitle = json["screen_title"];
    screendescription = json["screen_description"];
    moduleicon = json["module_icon"];
    modulecolor = json["module_color"];
    progress = json["progress"];
    questions = json["questions"] == null ? null : (json["questions"] as List).map((e) => QuestionItems.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["screen_title"] = screentitle;
    data["screen_description"] = screendescription;
    data["module_icon"] = moduleicon;
    data["module_color"] = modulecolor;
    data["progress"] = progress;
    if (questions != null) {
      data["questions"] = questions?.map((e) => e.toJson()).toList();
    }
    return data;
  }

  QuestionData copyWith({
    String? screentitle,
    String? screendescription,
    String? moduleicon,
    String? modulecolor,
    int? progress,
    List<QuestionItems>? questions,
  }) {
    return QuestionData(
      screentitle: screentitle ?? this.screentitle,
      screendescription: screendescription ?? this.screendescription,
      moduleicon: moduleicon ?? this.moduleicon,
      modulecolor: modulecolor ?? this.modulecolor,
      progress: progress ?? this.progress,
      questions: questions ?? this.questions,
    );
  }
}

class QuestionItems {
  bool? islocked;
  bool isExpanded;
  int? questionidpK;
  String? questiontitle;
  int? legacymoduleidfK;
  String? questiondescription;
  String? activecolorcode;
  String? deactivecolorcode;
  String? imagecode;
  String? createdat;
  dynamic updatedat;
  String? moduleicon;
  String? modulecolor;
  List<ModuleAnswerData>? answers;
  QuestionItems({
    this.islocked,
    this.isExpanded = false,
    this.questionidpK,
    this.questiontitle,
    this.legacymoduleidfK,
    this.questiondescription,
    this.activecolorcode,
    this.deactivecolorcode,
    this.imagecode,
    this.createdat,
    this.updatedat,
    this.moduleicon,
    this.modulecolor,
    this.answers = const [],
  });


  QuestionItems.empty()
      : islocked = false,
        isExpanded = false,
        questionidpK = null,
        questiontitle = '',
        legacymoduleidfK = null,
        questiondescription = '',
        activecolorcode = '',
        deactivecolorcode = '',
        imagecode = '',
        createdat = '',
        updatedat = null,
        moduleicon = '',
        modulecolor = '',
        answers = [];

  QuestionItems.fromJson(Map<String, dynamic> json)
      : islocked = json["is_locked"] ?? false,
        isExpanded = json["isExpanded"] ?? false,
        questionidpK = json["question_id_PK"],
        questiontitle = json["question_title"],
        legacymoduleidfK = json["legacy_module_id_FK"],
        questiondescription = json["question_description"],
        activecolorcode = json["active_color_code"],
        deactivecolorcode = json["deactive_color_code"],
        imagecode = json["image_code"],
        createdat = json["created_at"],
        updatedat = json["updated_at"],
        moduleicon = json["module_icon"],
        modulecolor = json["module_color"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["is_locked"] = islocked;
    data["isExpanded"] = isExpanded;
    data["question_id_PK"] = questionidpK;
    data["question_title"] = questiontitle;
    data["legacy_module_id_FK"] = legacymoduleidfK;
    data["question_description"] = questiondescription;
    data["active_color_code"] = activecolorcode;
    data["deactive_color_code"] = deactivecolorcode;
    data["image_code"] = imagecode;
    data["created_at"] = createdat;
    data["updated_at"] = updatedat;
    data["module_icon"] = moduleicon;
    data["module_color"] = modulecolor;
    data["answers"] = answers;
    return data;
  }

  QuestionItems copyWith({
    bool? islocked,
    bool? isExpanded,
    int? questionidpK,
    String? questiontitle,
    int? legacymoduleidfK,
    String? questiondescription,
    String? activecolorcode,
    String? deactivecolorcode,
    String? imagecode,
    String? createdat,
    dynamic updatedat,
    String? moduleicon,
    String? modulecolor,
    List<ModuleAnswerData>? answers,
  }) {
    return QuestionItems(
      islocked: islocked ?? this.islocked,
      isExpanded: isExpanded ?? this.isExpanded,
      questionidpK: questionidpK ?? this.questionidpK,
      questiontitle: questiontitle ?? this.questiontitle,
      legacymoduleidfK: legacymoduleidfK ?? this.legacymoduleidfK,
      questiondescription: questiondescription ?? this.questiondescription,
      activecolorcode: activecolorcode ?? this.activecolorcode,
      deactivecolorcode: deactivecolorcode ?? this.deactivecolorcode,
      imagecode: imagecode ?? this.imagecode,
      createdat: createdat ?? this.createdat,
      updatedat: updatedat ?? this.updatedat,
      moduleicon: moduleicon ?? this.moduleicon,
      modulecolor: modulecolor ?? this.modulecolor,
      answers: answers ?? this.answers,
    );
  }
}
