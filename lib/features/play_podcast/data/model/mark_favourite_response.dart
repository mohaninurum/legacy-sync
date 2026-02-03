class MarkFavouriteResponse {
  bool? status;
  String? message;
  MarkFavouriteResponse({this.status, this.message});

  MarkFavouriteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  MarkFavouriteResponse copyWith({bool? status, String? message}) => MarkFavouriteResponse(
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