class EndPodcastCallResponse {
  final bool status;
  final String message;

  EndPodcastCallResponse({required this.status, required this.message});

  factory EndPodcastCallResponse.fromJson(Map<String, dynamic> json) {
    return EndPodcastCallResponse(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
    );
  }
}
