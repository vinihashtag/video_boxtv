import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_boxtv/core/adapters/toast/toast_adapter.dart';

import '../../core/controllers/auth_controller.dart';
import '../../core/enums/status_page.dart';
import '../../data/repositories/auth/auth_repository_interface.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  final IAuthRepository _authRepository;
  final AuthController _authController;
  final IToastAdapter _toastAdapter;
  LoginController(this._authRepository, this._authController, this._toastAdapter);

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
        .then((_) => Future.delayed(const Duration(milliseconds: 800), () => status = StatusPage.idle));
    super.onInit();
  }

  // * Status Screen
  final _status = StatusPage.loadingMore.obs;
  StatusPage get status => _status.value;
  set status(StatusPage value) => _status.value = value;

  // * username
  final _username = ''.obs;
  String get username => _username.value;
  set username(String value) => _username.value = value;

  // * password
  final _password = ''.obs;
  String get password => _password.value;
  set password(String value) => _password.value = value;

  // * emailReset
  final _emailReset = ''.obs;
  String get emailReset => _emailReset.value;
  set emailReset(String value) => _emailReset.value = value;

  bool get isValid => username.trim().isNotEmpty && password.isNotEmpty && password.trim().length > 5;
  bool get isLoading => status == StatusPage.loading;

  // * Efetua login
  Future<void> login() async {
    try {
      status = StatusPage.loading;

      final result = await _authRepository.loginByUsernamePassword(username, password);

      if (result.isSuccess) {
        _authController.saveCurrentUser(result.data!);
        Get.offAllNamed(Routes.home);
      } else {
        _toastAdapter.messageError(text: result.error!.errorText);
        status = StatusPage.failure;
      }
    } catch (e) {
      status = StatusPage.failure;
      _toastAdapter.messageError(text: 'Erro ao fazer login, verifique.');
    }
  }
}
