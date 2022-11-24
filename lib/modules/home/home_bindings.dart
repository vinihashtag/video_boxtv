import 'package:get/get.dart';

import '../../data/repositories/video/video_repository.dart';
import '../../data/repositories/video/video_repository_interface.dart';
import 'home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IVideoRepository>(() => VideoRepository(Get.find(), Get.find(), Get.find()));
    Get.lazyPut(() => HomeController(Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
