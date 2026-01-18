class CreateNewPodcastModel {
  bool? status;
  String? message;
  int? podcastId;

  CreateNewPodcastModel({this.status, this.message, this.podcastId});

  CreateNewPodcastModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    podcastId = json['podcast_id'];
  }

  CreateNewPodcastModel copyWith({bool? status, String? message, int? podcastId}) =>
      CreateNewPodcastModel(
        status: status ?? this.status,
        message: message ?? this.message,
        podcastId: podcastId ?? this.podcastId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['podcast_id'] = podcastId;
    return map;
  }
}