import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

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
        // error: data,
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
      final log = Logger(identifier);
      log.severe('ERROR', e, stackTrace);
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
}
