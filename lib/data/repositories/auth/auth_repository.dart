import 'package:video_boxtv/core/adapters/rest_client/rest_client_adatper.dart';
import 'package:video_boxtv/core/utils/app_exceptions.dart';

import '../../models/app_model.dart';
import '../../models/response_model.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final IRestClientAdapter _restClient;

  AuthRepository(this._restClient);

  @override
  Future<ResponseModel<AppModel, Failure>> loginByUsernamePassword(String username, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      // return ResponseModel(error: ServerException(stackTrace: StackTrace.current));
      return ResponseModel(
          data: AppModel(
        appName: username,
        password: password,
        apiToken: '12335564640',
        lastAccess: DateTime.now(),
      ));
    } catch (e, s) {
      return ResponseModel(error: _restClient.handleError(e, s));
    }
  }
}
