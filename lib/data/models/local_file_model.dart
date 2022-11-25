import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:video_boxtv/core/utils/app_constants.dart';

class DownloadFileModel {
  final String directory;
  final List<LocalFileModel> files;
  DownloadFileModel({
    this.directory = AppConstants.directoryFiles,
    required this.files,
  });

  Map<String, dynamic> toMap() {
    return {
      'directory': directory,
      'files': files.map((x) => x.toMap()).toList(),
    };
  }

  factory DownloadFileModel.fromMap(Map<String, dynamic> map) {
    return DownloadFileModel(
      directory: map['directory'] ?? '',
      files: List<LocalFileModel>.from(map['files']?.map((x) => LocalFileModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadFileModel.fromJson(String source) => DownloadFileModel.fromMap(json.decode(source));

  @override
  String toString() => 'DownloadFileModel(directory: $directory, files: $files)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadFileModel && other.directory == directory && listEquals(other.files, files);
  }

  @override
  int get hashCode => directory.hashCode ^ files.hashCode;
}

class LocalFileModel {
  DateTime createdAt;
  String url;
  String localPath;

  LocalFileModel({
    required this.createdAt,
    required this.url,
    required this.localPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'url': url,
      'localPath': localPath,
    };
  }

  factory LocalFileModel.fromMap(Map<String, dynamic> map) {
    return LocalFileModel(
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      url: map['url'] ?? '',
      localPath: map['localPath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalFileModel.fromJson(String source) => LocalFileModel.fromMap(json.decode(source));

  @override
  String toString() => 'LocalFileModel(createdAt: $createdAt, url: $url, localPath: $localPath)';
}
