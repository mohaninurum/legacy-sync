class AddFavQueModel {
  AddFavQueModel({
      this.status, 
      this.message,});

  AddFavQueModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  bool? status;
  String? message;
AddFavQueModel copyWith({  bool? status,
  String? message,
}) => AddFavQueModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}