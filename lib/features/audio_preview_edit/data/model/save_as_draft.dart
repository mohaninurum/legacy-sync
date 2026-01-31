class SaveAsDraft {
  bool? status;
  String? message;
  SaveAsDraft({this.status, this.message});

  SaveAsDraft.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  SaveAsDraft copyWith({bool? status, String? message}) => SaveAsDraft(
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