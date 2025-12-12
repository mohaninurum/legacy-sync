class EditProfileDataResponseModel {
  EditProfileDataResponseModel({
      this.message, 
      this.data,});

  EditProfileDataResponseModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'];
  }
  String? message;
  bool? data;
EditProfileDataResponseModel copyWith({  String? message,
  bool? data,
}) => EditProfileDataResponseModel(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}