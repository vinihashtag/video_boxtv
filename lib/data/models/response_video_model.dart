// To parse this JSON data, do
//
//     final listVideosModel = listVideosModelFromMap(jsonString);

import 'dart:convert';

class ResponseVideoModel {
  final bool result;
  final String appName;
  final List<VideoModel> videos;
  final String registered;
  final String favoriteFruit;

  ResponseVideoModel({
    this.result = false,
    this.appName = '',
    this.videos = const [],
    this.registered = '',
    this.favoriteFruit = '',
  });

  factory ResponseVideoModel.fromJson(String str) => ResponseVideoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseVideoModel.fromMap(Map<String, dynamic> json) => ResponseVideoModel(
        result: json["result"] ?? false,
        appName: json["app_name"] ?? '',
        videos: List<VideoModel>.from((json["videos"] ?? []).map((x) => VideoModel.fromMap(x))),
        registered: json["registered"] ?? '',
        favoriteFruit: json["favoriteFruit"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "result": result,
        "app_name": appName,
        "videos": List<dynamic>.from(videos.map((x) => x.toMap())),
        "registered": registered,
        "favoriteFruit": favoriteFruit,
      };

  @override
  String toString() {
    return 'ResponseVideoModel(result: $result, appName: $appName, videos: $videos, registered: $registered, favoriteFruit: $favoriteFruit)';
  }
}

class VideoModel {
  final int id;
  final String url;

  VideoModel({required this.id, required this.url});

  factory VideoModel.fromJson(String str) => VideoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoModel.fromMap(Map<String, dynamic> json) => VideoModel(
        id: json["id"] ?? -1,
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toMap() => {"id": id, "url": url};

  @override
  String toString() => 'VideoModel(id: $id, url: $url)';
}
