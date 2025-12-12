class VerifyEmailResponse {
  final bool? status;
  final String? message;
  final VerifyEmailData? data;

  VerifyEmailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? VerifyEmailData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class VerifyEmailData {
  final int? isVerified;
  final String? email;

  VerifyEmailData({
    this.isVerified,
    this.email,
  });

  factory VerifyEmailData.fromJson(Map<String, dynamic> json) {
    return VerifyEmailData(
      isVerified: json['is_verified'] != null
          ? int.tryParse(json['is_verified'].toString())
          : null,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_verified': isVerified,
      'email': email,
    };
  }
}
