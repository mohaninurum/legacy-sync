import 'dart:convert';

class SignupModel {
  SignupModel({this.message, this.data});

  SignupModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? message;
  Data? data;

  SignupModel copyWith({String? message, Data? data}) => SignupModel(message: message ?? this.message, data: data ?? this.data);

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
  Data({this.user_id,this.social_login_provider,this.is_social, this.firstName, this.lastName, this.email, this.dateOfBirth, this.token, this.referralCode});

  Data.fromJson(dynamic json) {
    user_id = json['user_id'];
    social_login_provider = json['social_login_provider'];
    is_social = json['is_social'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    token = json['token'];
    referralCode = json['token'];
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

  Data copyWith({int? social_login_provider,int? user_id,int? is_social, String? firstName, String? lastName, String? email, String? dateOfBirth, String? token,String? referralCode}) => Data(user_id: user_id ?? this.user_id, firstName: firstName ?? this.firstName, lastName: lastName ?? this.lastName, email: email ?? this.email, dateOfBirth: dateOfBirth ?? this.dateOfBirth, token: token ?? this.token, referralCode: referralCode ?? this.referralCode);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = user_id;
    map['is_social'] = is_social;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['date_of_birth'] = dateOfBirth;
    map['token'] = token;
    map['social_login_provider'] = social_login_provider;
    map['referralCode'] = referralCode;
    return map;
  }
}
