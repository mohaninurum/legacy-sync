class MuxResponse {
  String? uploadUrl;
  String? uploadId;

  MuxResponse({
      this.uploadUrl, 
      this.uploadId,});

  MuxResponse.fromJson(dynamic json) {
    uploadUrl = json['uploadUrl'];
    uploadId = json['uploadId'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uploadUrl'] = uploadUrl;
    map['uploadId'] = uploadId;
    return map;
  }

}