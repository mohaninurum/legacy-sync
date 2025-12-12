class RemoveFavQueModel {
  RemoveFavQueModel({
      this.status, 
      this.message,});

  RemoveFavQueModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
RemoveFavQueModel copyWith({  String? status,
  String? message,
}) => RemoveFavQueModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}