import 'package:get/get.dart';

import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_repository_interface.dart';
import 'login_controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => AuthRepository(Get.find()));
    Get.lazyPut(() => LoginController(Get.find(), Get.find(), Get.find()));
  }
}
