class LoginResponse {
  final String? accessToken;

  const LoginResponse({this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String?,
    );
  }
}
