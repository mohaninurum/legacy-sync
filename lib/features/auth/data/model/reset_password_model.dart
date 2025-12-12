class ResetPasswordModel {
  String? message;
  String? email;
  String? password;
  ResetPasswordModel({
      this.message, 
      this.email, 
      this.password,});

  ResetPasswordModel.fromJson(dynamic json) {
    message = json['message'];
    email = json['email'];
    password = json['password'];
  }

ResetPasswordModel copyWith({  String? message,
  String? email,
  String? password,
}) => ResetPasswordModel(  message: message ?? this.message,
  email: email ?? this.email,
  password: password ?? this.password,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['email'] = email;
    map['password'] = password;
    return map;
  }

}