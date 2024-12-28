import 'package:skating_app/utils/api_config.dart';

class Constants {
  static const String METHOD_GET = "GET";
  static const String METHOD_POST = "POST";
  static const String METHOD_DELETE = "DELETE";
  static const String METHOD_PATCH = "PATCH";
  static const String METHOD_PUT = "PUT";
  static const int TIMEOUT_SEC = 120;

  static const String socket_url = "wss://${ApiConfig.baseUrl}/chunkMessage";
  // static const String socket_event = "chunkMessage";
  static const String token = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3Mjk2MjgyODgsInVzZXJJZCI6MTA0Mjc1NjQxNTMwOTA5MDgxNn0.4ioeT7-47VwHHU9ZhUiWWoWWbVioc-PZ2jhJ8btXNMM";
}