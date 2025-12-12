class EditProfilePicResponse {
  String? message;
  Data? data;

  EditProfilePicResponse({this.message, this.data});

  EditProfilePicResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }


  EditProfilePicResponse copyWith({String? message, Data? data}) => EditProfilePicResponse(message: message ?? this.message, data: data ?? this.data);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class Data {
  String? profileImage;

  Data({this.profileImage});

  Data.fromJson(dynamic json) {
    profileImage = json['profile_image'];
  }


  Data copyWith({String? profileImage}) => Data(profileImage: profileImage ?? this.profileImage);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profile_image'] = profileImage;
    return map;
  }
}
