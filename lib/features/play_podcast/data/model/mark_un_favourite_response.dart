class MarkUnFavouriteResponse {
  bool? status;
  String? message;
  MarkUnFavouriteResponse({this.status, this.message});

  MarkUnFavouriteResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  MarkUnFavouriteResponse copyWith({bool? status, String? message}) => MarkUnFavouriteResponse(
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