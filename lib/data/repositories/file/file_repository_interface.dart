import 'dart:io';

import '../../../core/utils/app_exceptions.dart';
import '../../models/response_model.dart';

abstract class IFileRepository {
  Future<ResponseModel<File, Failure>> downloadFileFromUrlByIsolate({required String url, required String folder});
  Future<ResponseModel<void, Failure>> deleteFile(String url);
  Future<ResponseModel<void, Failure>> clearDirectory(String dir);
}
