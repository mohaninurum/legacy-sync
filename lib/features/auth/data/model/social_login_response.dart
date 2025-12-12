class SocialLoginResponse {
  SocialLoginResponse({this.message, this.data});

  SocialLoginResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? message;
  Data? data;

  SocialLoginResponse copyWith({String? message, Data? data}) =>
      SocialLoginResponse(
        message: message ?? this.message,
        data: data ?? this.data,
      );

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
  int? userIdPK;
  int? social_login_provider;
  String? firstName;
  dynamic lastName;
  String? email;
  dynamic dateOfBirth;
  dynamic gender;
  dynamic mobileNumber;
  dynamic countryCode;
  dynamic password;
  dynamic profileImage;
  String? token;
  dynamic otp;
  dynamic goals;
  String? socialLoginId;
  int? socialLoginProvider;
  int? isSocial;
  String? createdAt;
  String? updatedAt;
  String? referralCode;
  bool? surveyQuestionCompleted;

  Data({
    this.userIdPK,
    this.social_login_provider,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.mobileNumber,
    this.countryCode,
    this.password,
    this.profileImage,
    this.token,
    this.otp,
    this.goals,
    this.socialLoginId,
    this.socialLoginProvider,
    this.isSocial,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.surveyQuestionCompleted,
  });

  Data.fromJson(dynamic json) {
    userIdPK = json['user_id_PK'];
    social_login_provider = json['social_login_provider'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    mobileNumber = json['mobile_number'];
    countryCode = json['country_code'];
    password = json['password'];
    profileImage = json['profile_image'];
    token = json['token'];
    otp = json['otp'];
    goals = json['goals'];
    socialLoginId = json['social_login_id'];
    socialLoginProvider = json['social_login_provider'];
    isSocial = json['is_social'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralCode = json['referralCode'];
    // referralCode = json['referralCode'];
    surveyQuestionCompleted = json['survey_question_completed'];
  }

  Data copyWith({
    int? userIdPK,
    int? social_login_provider,
    String? firstName,
    dynamic lastName,
    String? email,
    dynamic dateOfBirth,
    dynamic gender,
    dynamic mobileNumber,
    dynamic countryCode,
    dynamic password,
    dynamic profileImage,
    String? token,
    dynamic otp,
    dynamic goals,
    String? socialLoginId,
    int? socialLoginProvider,
    int? isSocial,
    String? createdAt,
    String? updatedAt,
    String? referralCode,
    bool? surveyQuestionCompleted,
  }) => Data(
    userIdPK: userIdPK ?? this.userIdPK,
    social_login_provider: social_login_provider ?? this.social_login_provider,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    countryCode: countryCode ?? this.countryCode,
    password: password ?? this.password,
    profileImage: profileImage ?? this.profileImage,
    token: token ?? this.token,
    otp: otp ?? this.otp,
    goals: goals ?? this.goals,
    socialLoginId: socialLoginId ?? this.socialLoginId,
    socialLoginProvider: socialLoginProvider ?? this.socialLoginProvider,
    isSocial: isSocial ?? this.isSocial,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    referralCode: referralCode ?? this.referralCode,
    surveyQuestionCompleted:
        surveyQuestionCompleted ?? this.surveyQuestionCompleted,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id_PK'] = userIdPK;
    map['social_login_provider'] = social_login_provider;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['date_of_birth'] = dateOfBirth;
    map['gender'] = gender;
    map['mobile_number'] = mobileNumber;
    map['country_code'] = countryCode;
    map['password'] = password;
    map['profile_image'] = profileImage;
    map['token'] = token;
    map['otp'] = otp;
    map['goals'] = goals;
    map['social_login_id'] = socialLoginId;
    map['social_login_provider'] = socialLoginProvider;
    map['is_social'] = isSocial;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['referralCode'] = referralCode;
    map['survey_question_completed'] = surveyQuestionCompleted;
    return map;
  }
}
