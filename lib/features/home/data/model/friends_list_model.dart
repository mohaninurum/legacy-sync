class FriendsListModel {
  FriendsListModel({this.status, this.message, this.data});

  FriendsListModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FriendsDataList.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<FriendsDataList>? data;

  FriendsListModel copyWith({bool? status, String? message, List<FriendsDataList>? data}) => FriendsListModel(status: status ?? this.status, message: message ?? this.message, data: data ?? this.data);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FriendsDataList {
  FriendsDataList({this.userIdPK, this.firstName, this.lastName, this.email, this.referalCode});

  FriendsDataList.fromJson(dynamic json) {
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

  FriendsDataList copyWith({int? userIdPK, String? firstName, String? lastName, String? email, String? referalCode}) =>
      FriendsDataList(userIdPK: userIdPK ?? this.userIdPK, firstName: firstName ?? this.firstName, lastName: lastName ?? this.lastName, email: email ?? this.email, referalCode: referalCode ?? this.referalCode);

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
