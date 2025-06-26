class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:3000";
  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$baseUrl/uploads/";

  static const String login = "auth/login";
  static const String register = "auth/register";
}