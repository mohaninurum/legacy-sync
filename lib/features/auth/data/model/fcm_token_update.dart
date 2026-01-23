class FcmTokenUpdate {
  bool? status;
  String? message;

  FcmTokenUpdate({this.status, this.message});

  FcmTokenUpdate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  FcmTokenUpdate copyWith({bool? status, String? message}) => FcmTokenUpdate(
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
