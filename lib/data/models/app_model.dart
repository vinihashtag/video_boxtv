import 'dart:convert';

class AppModel {
  final String appName;
  final String password;
  final String apiToken;
  final DateTime? lastAccess;

  AppModel({
    this.appName = '',
    this.password = '',
    this.apiToken = '',
    this.lastAccess,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'appName': appName});
    result.addAll({'password': password});
    result.addAll({'apiToken': apiToken});
    if (lastAccess != null) {
      result.addAll({'lastAccess': lastAccess!.millisecondsSinceEpoch});
    }

    return result;
  }

  factory AppModel.fromMap(Map<String, dynamic> map) {
    return AppModel(
      appName: map['appName'] ?? '',
      password: map['password'] ?? '',
      apiToken: map['apiToken'] ?? '',
      lastAccess: map['lastAccess'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastAccess']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppModel.fromJson(String source) => AppModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppModel(appName: $appName, password: $password, apiToken: $apiToken, lastAccess: $lastAccess)';
  }
}
