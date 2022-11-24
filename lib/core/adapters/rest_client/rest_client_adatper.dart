import 'package:video_boxtv/core/utils/app_exceptions.dart';

import '../../../data/models/response_model.dart';

enum MethodRequest { get, post, put, patch, delete, download }

abstract class IRestClientAdapter {
  Future<ResponseModel> request({
    required String url,
    required MethodRequest method,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic cancelToken,
    void Function(int, int)? updateProgress,
    void Function(int, int)? downloadProgress,
    String? pathWillSaved,
    Duration? validateCache,
  });

  Failure handleError(dynamic error, StackTrace stackTrace);

  void close();
}
