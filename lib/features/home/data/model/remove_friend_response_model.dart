class RemoveFriendResponseModel {
  bool? status;
  String? message;

  RemoveFriendResponseModel({this.status, this.message});

  RemoveFriendResponseModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }

  RemoveFriendResponseModel copyWith({bool? status, String? message}) =>
      RemoveFriendResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}
