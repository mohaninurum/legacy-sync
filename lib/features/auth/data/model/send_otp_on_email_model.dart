class SendOtpOnEmailModel {
  String? message;
  String? otp;
  String? email;
  SendOtpOnEmailModel({
      this.message, 
      this.otp, 
      this.email,});

  SendOtpOnEmailModel.fromJson(dynamic json) {
    message = json['message'];
    otp = json['otp'];
    email = json['email'];
  }

SendOtpOnEmailModel copyWith({  String? message,
  String? otp,
  String? email,
}) => SendOtpOnEmailModel(  message: message ?? this.message,
  otp: otp ?? this.otp,
  email: email ?? this.email,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['otp'] = otp;
    map['email'] = email;
    return map;
  }

}