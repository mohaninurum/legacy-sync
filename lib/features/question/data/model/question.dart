class QueationModel {
  bool? status;
  String? message;
  List<Data>? data;

  QueationModel({this.status, this.message, this.data});

  QueationModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data =
        json["data"] == null
            ? null
            : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    data["message"] = message;
    data["data"] = data;
    return data;
  }

  QueationModel copyWith({bool? status, String? message, List<Data>? data}) =>
      QueationModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  // Initial fallback data when server fetch fails
  static QueationModel getInitialData() {
    return QueationModel(
      status: true,
      message: "Survey questions retrieved successfully.",
      data: [
        Data(
          questionidpK: 1,
          questionno: 1,
          questiontext: "What kind of legacy do you most hope to create?",
          options: [
            Option(
              optionidpK: 1,
              questionidfK: 1,
              option: "Pass on life stories and memories",
              optioncode: "q1o1",
            ),
            Option(
              optionidpK: 2,
              questionidfK: 1,
              option: "Share wisdom and life lessons",
              optioncode: "q1o2",
            ),
            Option(
              optionidpK: 3,
              questionidfK: 1,
              option: "Document family history and traditions",
              optioncode: "q1o3",
            ),
            Option(
              optionidpK: 4,
              questionidfK: 1,
              option: "Leave behind my core values and beliefs",
              optioncode: "q1o4",
            ),
            Option(
              optionidpK: 5,
              questionidfK: 1,
              option: "Connect deeply with future generations",
              optioncode: "q1o5",
            ),
            Option(
              optionidpK: 6,
              questionidfK: 1,
              option: "Gain personal clarity and fulfillment",
              optioncode: "q1o6",
            ),
          ],
        ),
        Data(
          questionidpK: 2,
          questionno: 2,
          questiontext:
              "How will you support your family with comfort or advice in future moments when you can't be there?",
          options: [
            Option(
              optionidpK: 7,
              questionidfK: 2,
              option:
                  "I wish I could still offer them my words of wisdom directly.",
              optioncode: "q2o1",
            ),
            Option(
              optionidpK: 8,
              questionidfK: 2,
              option:
                  "I want to provide a lasting source of support and encouragement.",
              optioncode: "q2o2",
            ),
            Option(
              optionidpK: 9,
              questionidfK: 2,
              option:
                  "I worry about them navigating life's challenges without my voice.",
              optioncode: "q2o3",
            ),
            Option(
              optionidpK: 10,
              questionidfK: 2,
              option:
                  "I long for a way to always be present and accessible for them.",
              optioncode: "q2o4",
            ),
          ],
        ),
        Data(
          questionidpK: 3,
          questionno: 3,
          questiontext:
              "Beyond notes or photos, do you wish your family could interact with your advice – asking questions, getting your specific responses, anytime they need to hear directly from you?",
          options: [
            Option(
              optionidpK: 11,
              questionidfK: 3,
              option:
                  "Yes, a dynamic, conversational connection would be incredible.",
              optioncode: "q3o1",
            ),
            Option(
              optionidpK: 12,
              questionidfK: 3,
              option:
                  "I want them to feel my presence in a living, interactive way.",
              optioncode: "q3o2",
            ),
            Option(
              optionidpK: 13,
              questionidfK: 3,
              option:
                  "That's exactly the kind of responsive, enduring legacy I envision.",
              optioncode: "q3o3",
            ),
            Option(
              optionidpK: 14,
              questionidfK: 3,
              option:
                  "It's the ultimate way to ensure my guidance is always there on demand.",
              optioncode: "q3o4",
            ),
          ],
        ),
        Data(
          questionidpK: 4,
          questionno: 4,
          questiontext:
              "How confident are you that every key story, lesson, and insight from your unique life will be fully captured and easily accessible for your family's future?",
          options: [
            Option(
              optionidpK: 15,
              questionidfK: 4,
              option:
                  "I worry that important details or nuances might be missed forever.",
              optioncode: "q4o1",
            ),
            Option(
              optionidpK: 16,
              questionidfK: 4,
              option:
                  "It feels like a daunting task to capture it all comprehensively myself.",
              optioncode: "q4o2",
            ),
            Option(
              optionidpK: 17,
              questionidfK: 4,
              option:
                  "I need assurance that my full, authentic story will be preserved.",
              optioncode: "q4o3",
            ),
            Option(
              optionidpK: 18,
              questionidfK: 4,
              option:
                  "I desire a complete and organized way to ensure nothing is overlooked.",
              optioncode: "q4o4",
            ),
          ],
        ),
        Data(
          questionidpK: 5,
          questionno: 5,
          questiontext:
              "Do you worry your life's wisdom might fade, unheard by future generations?",
          options: [
            Option(
              optionidpK: 19,
              questionidfK: 5,
              option: "Yes, I often wonder how my legacy will truly live on.",
              optioncode: "q5o1",
            ),
            Option(
              optionidpK: 20,
              questionidfK: 5,
              option:
                  "I hope my experiences can still guide my loved ones, even when I'm gone.",
              optioncode: "q5o2",
            ),
            Option(
              optionidpK: 21,
              questionidfK: 5,
              option:
                  "It's a concern that my unique voice might be lost over time.",
              optioncode: "q5o3",
            ),
            Option(
              optionidpK: 22,
              questionidfK: 5,
              option:
                  "I wish there was a guaranteed way for my essence to endure.",
              optioncode: "q5o4",
            ),
          ],
        ),
        Data(
          questionidpK: 6,
          questionno: 6,
          questiontext:
              "Do you seek a guided, high-quality solution to capture your life story, ensuring every detail is preserved with utmost care, authenticity, and long-term security?",
          options: [
            Option(
              optionidpK: 23,
              questionidfK: 6,
              option:
                  "Yes, I need a reliable and trustworthy partner for this profound task.",
              optioncode: "q6o1",
            ),
            Option(
              optionidpK: 24,
              questionidfK: 6,
              option:
                  "I want my legacy expertly and authentically preserved for generations.",
              optioncode: "q6o2",
            ),
            Option(
              optionidpK: 25,
              questionidfK: 6,
              option:
                  "I value a solution that truly understands the significance of my story.",
              optioncode: "q6o3",
            ),
            Option(
              optionidpK: 26,
              questionidfK: 6,
              option:
                  "I need a dedicated approach to securely preserve my voice for the future.",
              optioncode: "q6o4",
            ),
          ],
        ),
        Data(
          questionidpK: 7,
          questionno: 7,
          questiontext:
              "Do you see creating and maintaining this profound, interactive legacy as an invaluable and essential long-term investment for your family's future well-being?",
          options: [
            Option(
              optionidpK: 27,
              questionidfK: 7,
              option:
                  "Absolutely, it's a priceless investment in their comfort and guidance.",
              optioncode: "q7o1",
            ),
            Option(
              optionidpK: 28,
              questionidfK: 7,
              option:
                  "It's the most meaningful and essential gift I can possibly secure for them.",
              optioncode: "q7o2",
            ),
            Option(
              optionidpK: 29,
              questionidfK: 7,
              option:
                  "Yes, ensuring this unique connection endures is of utmost importance.",
              optioncode: "q7o3",
            ),
            Option(
              optionidpK: 30,
              questionidfK: 7,
              option:
                  "I deeply understand its profound, lasting value to my entire family.",
              optioncode: "q7o4",
            ),
          ],
        ),
        Data(
          questionidpK: 8,
          questionno: 8,
          questiontext:
              "Is now the definitive moment to make the crucial choice to prevent your unique voice from fading and ensure your enduring presence lives vibrantly for your family's future, providing continuous comfort and wisdom?",
          options: [
            Option(
              optionidpK: 31,
              questionidfK: 8,
              option:
                  "Yes, this is the essential step I need to take right now.",
              optioncode: "q8o1",
            ),
            Option(
              optionidpK: 32,
              questionidfK: 8,
              option:
                  "I'm ready to secure this invaluable gift for generations to come.",
              optioncode: "q8o2",
            ),
            Option(
              optionidpK: 33,
              questionidfK: 8,
              option:
                  "It's a small commitment for such a profound and everlasting impact.",
              optioncode: "q8o3",
            ),
            Option(
              optionidpK: 34,
              questionidfK: 8,
              option:
                  "Absolutely, I'm ready to move forward and create this living legacy.",
              optioncode: "q8o4",
            ),
          ],
        ),
        Data(
          questionidpK: 9,
          questionno: 9,
          questiontext: "What is your gender?",
          options: [
            Option(
              optionidpK: 35,
              questionidfK: 9,
              option: "Female",
              optioncode: "female",
            ),
            Option(
              optionidpK: 36,
              questionidfK: 9,
              option: "Male",
              optioncode: "male",
            ),
          ],
        ),
        Data(
          questionidpK: 10,
          questionno: 10,
          questiontext: "Where did you hear about us?",
          options: [
            Option(
              optionidpK: 37,
              questionidfK: 10,
              option: "Google",
              optioncode: "google",
            ),
            Option(
              optionidpK: 38,
              questionidfK: 10,
              option: "X",
              optioncode: "x",
            ),
            Option(
              optionidpK: 39,
              questionidfK: 10,
              option: "Tiktok",
              optioncode: "tiktok",
            ),
            Option(
              optionidpK: 40,
              questionidfK: 10,
              option: "Facebook",
              optioncode: "facebook",
            ),
            Option(
              optionidpK: 41,
              questionidfK: 10,
              option: "Instagram",
              optioncode: "instagram",
            ),
          ],
        ),
        Data(
          questionidpK: 11,
          questionno: 11,
          questiontext: "Finally\nA little more about you",
          options: [
            Option(
              optionidpK: 42,
              questionidfK: 11,
              option: "Name",
              optioncode: "name",
            ),
            Option(
              optionidpK: 43,
              questionidfK: 11,
              option: "Age",
              optioncode: "age",
            ),
          ],
        ),
      ],
    );
  }
}

class Data {
  int? questionidpK;
  int? questionno;
  String? questiontext;
  List<Option>? options;

  Data({this.questionidpK, this.questionno, this.questiontext, this.options});

  Data.fromJson(Map<String, dynamic> json) {
    questionidpK = json["question_id_PK"];
    questionno = json["question_no"];
    questiontext = json["question_text"];
    options =
        json["options"] == null
            ? null
            : (json["options"] as List).map((e) => Option.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["question_id_PK"] = questionidpK;
    data["question_no"] = questionno;
    data["question_text"] = questiontext;
    if (options != null) {
      data["options"] = options?.map((e) => e.toJson()).toList();
    }
    return data;
  }

  Data copyWith({
    int? questionidpK,
    int? questionno,
    String? questiontext,
    List<Option>? options,
  }) => Data(
    questionidpK: questionidpK ?? this.questionidpK,
    questionno: questionno ?? this.questionno,
    questiontext: questiontext ?? this.questiontext,
    options: options ?? this.options,
  );
}

class Option {
  int? optionidpK;
  int? questionidfK;
  String? option;
  String? optioncode;

  Option({this.optionidpK, this.questionidfK, this.option, this.optioncode});

  Option.fromJson(Map<String, dynamic> json) {
    optionidpK = json["option_id_PK"];
    questionidfK = json["question_id_FK"];
    option = json["option"];
    optioncode = json["option_code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["option_id_PK"] = optionidpK;
    data["question_id_FK"] = questionidfK;
    data["option"] = option;
    data["option_code"] = optioncode;
    return data;
  }

  Option copyWith({
    int? optionidpK,
    int? questionidfK,
    String? option,
    String? optioncode,
  }) => Option(
    optionidpK: optionidpK ?? this.optionidpK,
    questionidfK: questionidfK ?? this.questionidfK,
    option: option ?? this.option,
    optioncode: optioncode ?? this.optioncode,
  );
}
