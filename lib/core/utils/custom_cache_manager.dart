// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:io' as io;

import 'package:file/file.dart' as f;
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart' as filesystem;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'helpers.dart';

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const keyCustomCacheVideo = 'gotchosenCachedVideoData';
  static final CustomCacheManager _instanceVideo = CustomCacheManager._video();
  factory CustomCacheManager.fromVideo() => _instanceVideo;

  CustomCacheManager._video()
      : super(
          Config(
            keyCustomCacheVideo,
            maxNrOfCacheObjects: 20,
            stalePeriod: const Duration(days: 7),
            repo: JsonCacheInfoRepository(databaseName: keyCustomCacheVideo),
            fileSystem: _IOFileSystem(keyCustomCacheVideo, 'videos'),
            fileService: HttpFileService(),
          ),
        );

  /// Clear all cache
  static Future<void> clear({
    bool clearBackgroundImages = true,
    bool clearLiveImages = true,
    bool clearCacheVideo = false,
    Map<String, String>? urlWillBeRemoved,
  }) async {
    if (clearBackgroundImages) imageCache.clear();

    if (clearLiveImages) imageCache.clearLiveImages();

    await Future.wait([
      if (clearCacheVideo) _instanceVideo.emptyCache(),
      if (urlWillBeRemoved?.containsKey('video') ?? false) _instanceVideo.removeFile(urlWillBeRemoved!['video']!),
    ]);

    Helpers.debug('ALL CACHE WAS CLEANED');
  }

  /// Recursively calculate the size of the file
  Future<double> getTotalSizeOfFilesInDir(dynamic target) async {
    try {
      if (target is io.File) {
        int length = target.lengthSync();
        return length.toDouble();
      }
      if (target is io.Directory) {
        final List<io.FileSystemEntity> children = target.listSync();
        double total = 0;
        for (final io.FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
        return total;
      }
      return 0;
    } catch (e) {
      Helpers.debug(e);
      return 0;
    }
  }

  ///Recursively delete directories
  Future<void> clearDirectory(dynamic target) async {
    try {
      if (target is io.Directory) {
        final List<io.FileSystemEntity> children = target.listSync();
        for (final io.FileSystemEntity child in children) {
          await clearDirectory(child);
        }
      }
      await target.delete();
    } catch (e) {
      Helpers.debug(e);
    }
  }
}

class _IOFileSystem implements filesystem.FileSystem {
  final Future<f.Directory> _fileDir;
  final String initialFolder;

  _IOFileSystem(String key, this.initialFolder) : _fileDir = createDirectory(key, initialFolder);

  static Future<f.Directory> createDirectory(String key, String initialFolder) async {
    late final io.Directory baseDir;

    try {
      if (io.Platform.isAndroid) {
        baseDir = (await path_provider.getExternalStorageDirectory()) ??
            await path_provider.getApplicationDocumentsDirectory();
      } else {
        baseDir = await path_provider.getLibraryDirectory();
      }
    } catch (e) {
      baseDir = await path_provider.getApplicationDocumentsDirectory();
    }

    final String target = path.join(baseDir.path, initialFolder, key);

    final directory = const LocalFileSystem().directory((target));
    await directory.create(recursive: true);
    return directory;
  }

  @override
  Future<f.File> createFile(String name) async => (await _fileDir).childFile(name);
}
