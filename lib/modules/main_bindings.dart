import 'package:get/get.dart';
import 'package:video_boxtv/core/adapters/local_storage/local_storage.dart';
import 'package:video_boxtv/core/adapters/local_storage/local_storage_adapter.dart';
import 'package:video_boxtv/core/adapters/toast/toast.dart';

import '../core/adapters/rest_client/rest_client.dart';
import '../core/adapters/rest_client/rest_client_adatper.dart';
import '../core/adapters/secure_storage/secure_storage.dart';
import '../core/adapters/secure_storage/secure_storage_adapter.dart';
import '../core/adapters/toast/toast_adapter.dart';
import '../core/controllers/auth_controller.dart';
import '../core/controllers/connectivity_controller.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    // Adapters
    Get.lazyPut<IRestClientAdapter>(() => RestClientAdapter(), fenix: true);
    Get.lazyPut<ILocalStorageAdapter>(() => LocalStorageAdapter(), fenix: true);
    Get.lazyPut<ISecureStorageAdapter>(() => SecureStorageAdapter(), fenix: true);
    Get.lazyPut<IToastAdapter>(() => ToastAdapter(), fenix: true);

    // Controllers
    Get.put(ConnectivityController());
    Get.lazyPut(() => AuthController(Get.find(), Get.find()), fenix: true);
  }
}
