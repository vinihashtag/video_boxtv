import 'package:video_boxtv/core/utils/app_exceptions.dart';

import '../../models/app_model.dart';
import '../../models/response_model.dart';

abstract class IAuthRepository {
  Future<ResponseModel<AppModel, Failure>> loginByUsernamePassword(String username, String password);
}
