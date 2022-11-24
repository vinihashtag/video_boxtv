import 'package:get/get.dart';
import 'package:video_boxtv/core/adapters/local_storage/local_storage_adapter.dart';

import '../../data/models/app_model.dart';
import '../adapters/secure_storage/secure_storage_adapter.dart';
import '../utils/app_constants.dart';

class AuthController extends GetxController {
  final ISecureStorageAdapter _secureStorageAdapter;
  final ILocalStorageAdapter _localStorageAdapter;
  AuthController(this._secureStorageAdapter, this._localStorageAdapter);

  final _appModel = AppModel().obs;
  AppModel get app => _appModel.value;
  set app(AppModel value) {
    _appModel.value = value;
    _appModel.refresh();
  }

  bool get isAuthenticated => app.appName.trim().isNotEmpty && app.apiToken.trim().isNotEmpty;

  Future<void> getCurrentUser() async {
    final result = await _secureStorageAdapter.read(AppConstants.userKey);

    if (result != null) app = AppModel.fromJson(result);
  }

  Future<void> saveCurrentUser(AppModel appModel) async {
    app = appModel;
    await _secureStorageAdapter.write(AppConstants.userKey, app.toJson());
  }

  Future<void> logout() async {
    app = AppModel();
    _localStorageAdapter.clear();
    return _secureStorageAdapter.remove(AppConstants.userKey);
  }
}
