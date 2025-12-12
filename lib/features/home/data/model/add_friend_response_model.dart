class AddFriendResponseModel {
  AddFriendResponseModel({
      this.status, 
      this.message, 
      this.data,});

  AddFriendResponseModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;
AddFriendResponseModel copyWith({  bool? status,
  String? message,
  Data? data,
}) => AddFriendResponseModel(  status: status ?? this.status,
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

class Data {
  Data({
      this.userIdPK, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.referalCode,});

  Data.fromJson(dynamic json) {
    userIdPK = json['user_id_PK'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    referalCode = json['referal_code'];
  }
  int? userIdPK;
  String? firstName;
  String? lastName;
  String? email;
  String? referalCode;
Data copyWith({  int? userIdPK,
  String? firstName,
  String? lastName,
  String? email,
  String? referalCode,
}) => Data(  userIdPK: userIdPK ?? this.userIdPK,
  firstName: firstName ?? this.firstName,
  lastName: lastName ?? this.lastName,
  email: email ?? this.email,
  referalCode: referalCode ?? this.referalCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id_PK'] = userIdPK;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['referal_code'] = referalCode;
    return map;
  }

}