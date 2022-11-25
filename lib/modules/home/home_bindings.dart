import 'package:get/get.dart';
import 'package:video_boxtv/data/repositories/file/file_repository.dart';
import 'package:video_boxtv/data/repositories/file/file_repository_interface.dart';

import '../../data/repositories/video/video_repository.dart';
import '../../data/repositories/video/video_repository_interface.dart';
import 'home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IFileRepository>(() => FileRepository());
    Get.lazyPut<IVideoRepository>(() => VideoRepository(Get.find(), Get.find(), Get.find()));
    Get.lazyPut(() => HomeController(Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
