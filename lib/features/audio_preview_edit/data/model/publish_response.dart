class PublishResponse {
  bool? status;
  String? message;
  PublishResponse({this.status, this.message});

  PublishResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  PublishResponse copyWith({bool? status, String? message}) => PublishResponse(
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