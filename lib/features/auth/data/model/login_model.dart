import 'dart:convert';

class LoginModel {
  LoginModel({this.message, this.data});

  LoginModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? message;
  Data? data;

  LoginModel copyWith({String? message, Data? data}) => LoginModel(message: message ?? this.message, data: data ?? this.data);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.user_id,
    this.social_login_provider,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.token,
    this.referralCode,
    this.is_social,
    this.survey_question_completed,
    this.legacy_started,
    this.memories_captured,
  });

  Data.fromJson(dynamic json) {
    user_id = json['user_id'];
    social_login_provider = json['social_login_provider'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    token = json['token'];
    referralCode = json['referralCode'];
    is_social = json['is_social'];
    memories_captured = json['memories_captured'];
    legacy_started = json['legacy_started'];
    survey_question_completed = json['survey_question_completed'];
  }

  int? user_id;
  int? social_login_provider;
  int? is_social;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  String? token;
  String? referralCode;
  String? legacy_started;
  int? memories_captured;
  bool? survey_question_completed;

  Data copyWith({
    int? user_id,
    int? social_login_provider,
    int? is_social,
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? token,
    String? referralCode,
    bool? survey_question_completed,
    String? legacy_started,
    int? memories_captured,
  }) => Data(
    user_id: user_id ?? this.user_id,
    social_login_provider: social_login_provider ?? this.social_login_provider,
    is_social: is_social ?? this.is_social,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    token: token ?? this.token,
    referralCode: referralCode ?? this.referralCode,
    survey_question_completed: survey_question_completed ?? this.survey_question_completed,
    legacy_started: legacy_started ?? this.legacy_started,
    memories_captured: memories_captured ?? this.memories_captured,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = user_id;
    map['social_login_provider'] = social_login_provider;
    map['is_social'] = is_social;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['date_of_birth'] = dateOfBirth;
    map['token'] = token;
    map['referralCode'] = referralCode;
    map['survey_question_completed'] = survey_question_completed;
    map['legacy_started'] = legacy_started;
    map['memories_captured'] = memories_captured;
    return map;
  }
}
