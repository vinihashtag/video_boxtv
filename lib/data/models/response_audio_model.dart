import 'dart:convert';

class AudioPlayerModel {
  final bool result;
  final String appName;
  final String appLogin;
  String appStreaming;
  final String appToken;
  final String appUrl;

  AudioPlayerModel({
    required this.result,
    required this.appName,
    required this.appLogin,
    required this.appStreaming,
    required this.appToken,
    required this.appUrl,
  });

  factory AudioPlayerModel.fromJson(String str) => AudioPlayerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AudioPlayerModel.fromMap(Map<String, dynamic> json) => AudioPlayerModel(
        result: json["result"] ?? false,
        appName: json["app_name"] ?? '',
        appLogin: json["app_login"] ?? '',
        appStreaming: json["app_streaming"] ?? '',
        appToken: json["app_token"] ?? '',
        appUrl: json["app_url"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "result": result,
        "app_name": appName,
        "app_login": appLogin,
        "app_streaming": appStreaming,
        "app_token": appToken,
        "app_url": appUrl,
      };

  @override
  String toString() {
    return 'AudioPlayerModel(result: $result, appName: $appName, appLogin: $appLogin, appStreaming: $appStreaming, appToken: $appToken, appUrl: $appUrl)';
  }
}
