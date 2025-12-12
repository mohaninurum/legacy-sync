class ProfileModel {
  ProfileModel({this.status, this.message, this.data});

  ProfileModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  ProfileData? data;
  ProfileModel copyWith({bool? status, String? message, ProfileData? data}) =>
      ProfileModel(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class ProfileData {
  ProfileData({
    this.userIdPK,
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
    this.referalCode,
    this.createdAt,
    this.updatedAt,
  });

  ProfileData.fromJson(dynamic json) {
    userIdPK = json['user_id_PK'];
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
    referalCode = json['referal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? userIdPK;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  dynamic gender;
  dynamic mobileNumber;
  dynamic countryCode;
  String? password;
  String? profileImage;
  String? token;
  dynamic otp;
  dynamic goals;
  dynamic socialLoginId;
  dynamic socialLoginProvider;
  int? isSocial;
  String? referalCode;
  String? createdAt;
  dynamic updatedAt;
  ProfileData copyWith({
    int? userIdPK,
    String? firstName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    dynamic gender,
    dynamic mobileNumber,
    dynamic countryCode,
    String? password,
    String? profileImage,
    String? token,
    dynamic otp,
    dynamic goals,
    dynamic socialLoginId,
    dynamic socialLoginProvider,
    int? isSocial,
    String? referalCode,
    String? createdAt,
    dynamic updatedAt,
  }) => ProfileData(
    userIdPK: userIdPK ?? this.userIdPK,
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
    referalCode: referalCode ?? this.referalCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id_PK'] = userIdPK;
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
    map['referal_code'] = referalCode;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
