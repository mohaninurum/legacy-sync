class UpdatedCardDetails {
  String? message;
  Data? data;

  UpdatedCardDetails({
      this.message, 
      this.data,});

  UpdatedCardDetails.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  String? referralCode;
  int? isSocial;
  int? socialLoginProvider;
  bool? surveyQuestionCompleted;
  String? legacyStarted;
  int? memoriesCaptured;
  int? totalWisdom;
  String? token;

  Data({
      this.userId, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.dateOfBirth, 
      this.referralCode, 
      this.isSocial, 
      this.socialLoginProvider, 
      this.surveyQuestionCompleted, 
      this.legacyStarted, 
      this.memoriesCaptured, 
      this.totalWisdom, 
      this.token,});

  Data.fromJson(dynamic json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    referralCode = json['referralCode'];
    isSocial = json['is_social'];
    socialLoginProvider = json['social_login_provider'];
    surveyQuestionCompleted = json['survey_question_completed'];
    legacyStarted = json['legacy_started'];
    memoriesCaptured = json['memories_captured'];
    totalWisdom = json['total_wisdom'];
    token = json['token'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['date_of_birth'] = dateOfBirth;
    map['referralCode'] = referralCode;
    map['is_social'] = isSocial;
    map['social_login_provider'] = socialLoginProvider;
    map['survey_question_completed'] = surveyQuestionCompleted;
    map['legacy_started'] = legacyStarted;
    map['memories_captured'] = memoriesCaptured;
    map['total_wisdom'] = totalWisdom;
    map['token'] = token;
    return map;
  }

}