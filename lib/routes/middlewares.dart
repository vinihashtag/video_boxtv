import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/auth_controller.dart';
import 'app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    return authController.isAuthenticated ? null : const RouteSettings(name: Routes.login);
  }
}
