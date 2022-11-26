import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class Helpers {
  Helpers._();

  /// Use this function instead of print and get some logs with
  /// highlight on the Debug Console
  ///
  /// This is only an alias to [developer.log] function
  static void debug(dynamic message, {Object? data, int? sequence}) {
    // Create a conditional breakpoint to debbuger
    // debugger(when: true, message: 'marco: $state');
    if (kDebugMode) {
      log(
        '$message',
        name: 'tvbox_videos',
        sequenceNumber: sequence ?? 0,
        time: DateTime.now(),
      );
    }
  }

  /// Use this function instead of print error and get some logs with
  /// highlight on the Debug Console
  static void error(Object? e, StackTrace? stackTrace, {required String identifier}) {
    // Create a conditional breakpoint to debbuger
    // debugger(when: true, message: 'marco: $state');
    if (kDebugMode) {
      log(
        identifier,
        error: e,
        stackTrace: stackTrace,
        name: 'tvbox_videos',
        time: DateTime.now(),
      );
      // final log = Logger(identifier);
      // log.severe('ERROR', e, stackTrace);
    }
  }

  /// Use this function instead of print error and get some logs with
  /// highlight on the Debug Console
  static void info({required String message}) {
    // Create a conditional breakpoint to debbuger
    // debugger(when: true, message: 'marco: $state');
    if (kDebugMode) {
      final log = Logger('tvbox_videos');
      log.info(message);
    }
  }

  /// Get directory by platform
  static Future<Directory> getDirectory() async {
    late final Directory baseDir;

    try {
      if (Platform.isAndroid) {
        baseDir = (await getExternalStorageDirectory()) ?? await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS) {
        baseDir = await getLibraryDirectory();
      } else {
        baseDir = await getTemporaryDirectory();
      }
    } catch (e) {
      baseDir = await getTemporaryDirectory();
    }

    return baseDir;
  }

  static String timeString(Duration duration) {
    String result = '';

    final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    final minut = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secon = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    result += '$hours:';
    result += '$minut:';

    return result += secon;
  }
}
