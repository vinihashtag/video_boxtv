import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:video_boxtv/core/controllers/auth_controller.dart';
import 'package:video_boxtv/core/utils/helpers.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final bool requestByIsolate;

  AuthInterceptor({this.requestByIsolate = false});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // ? Change the content-type header when it is FormData
      if (options.data is FormData) options.contentType = "multipart/form-data; charset=utf-8";

      if (!options.headers.containsKey('Accept-Language')) {
        options.headers["Accept-Language"] = Platform.localeName.replaceAll("_", "-");
      }

      // ? when request come by isolate will be continued
      if (requestByIsolate) return handler.next(options);

      final authController = Get.find<AuthController>();

      if (authController.isAuthenticated && authController.app.apiToken.trim().isNotEmpty) {
        options.queryParameters["token"] = authController.app.apiToken;
      }
    } catch (e, s) {
      Helpers.error(identifier: '[AuthInterceptor][onRequest]', e, s);
    }

    return super.onRequest(options, handler);
  }
}
