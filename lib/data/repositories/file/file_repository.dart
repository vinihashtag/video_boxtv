import 'dart:io';

import 'package:combine/combine.dart';
import 'package:get/utils.dart';
import 'package:path/path.dart';
import 'package:video_boxtv/core/adapters/rest_client/rest_client.dart';
import 'package:video_boxtv/core/utils/helpers.dart';

import '../../../core/adapters/rest_client/rest_client_adatper.dart';
import '../../../core/utils/app_exceptions.dart';
import '../../models/response_model.dart';
import 'file_repository_interface.dart';

class FileRepository implements IFileRepository {
  @override
  Future<ResponseModel<File, Failure>> downloadFileFromUrlByIsolate(
      {required String url, required String? folder}) async {
    if (!GetPlatform.isAndroid && !GetPlatform.isIOS) {
      return ResponseModel(
          error: DefaultException(
        errorText: 'Plataforma não suporta leitura e escrita de arquivos',
        stackTrace: StackTrace.empty,
      ));
    }

    final Directory baseDir = await Helpers.getDirectory();

    if (folder != null && !Directory(join(baseDir.path, folder)).existsSync()) {
      await Directory(join(baseDir.path, folder)).create(recursive: true);
    }

    final params = <String, dynamic>{
      'url': url,
      'baseDir': baseDir.path,
      'finalDir': folder,
    };

    return await CombineWorker().executeWithArg(
      (Map<String, dynamic> params) async {
        final restClient = RestClientAdapter(requestByIsolate: true);

        final url = params['url'] as String;
        final baseDir = params['baseDir'] as String;
        final finalDir = params['finalDir'] as String?;
        final customFileName = params['customFileName'] as String?;

        try {
          // * Remove all query string and everything before the extenssion name
          final String ext = url.replaceAll(RegExp(r'\?.+'), '').replaceAll(RegExp(r'.+\.'), '');

          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

          final String target = join(baseDir, finalDir, customFileName ?? timestamp);

          final file = File("$target.$ext");

          final resp = await restClient.request(url: url, method: MethodRequest.download);

          if (resp.isSuccess) {
            file.writeAsBytesSync(resp.data);

            return ResponseModel(data: file);
          } else {
            return ResponseModel(error: resp.error);
          }
        } catch (e, stackTrace) {
          return ResponseModel(error: restClient.handleError(e, stackTrace));
        } finally {
          restClient.close();
        }
      },
      params,
    );
  }

  @override
  Future<ResponseModel<void, Failure>> deleteFile(String path) async {
    try {
      if (!GetPlatform.isAndroid && !GetPlatform.isIOS) return ResponseModel();

      final File file = File(path);

      if (file.existsSync()) await file.delete(recursive: true);

      return ResponseModel();
    } catch (e, s) {
      return ResponseModel(error: DefaultException(errorText: e.toString(), stackTrace: s));
    }
  }

  @override
  Future<ResponseModel<void, Failure>> clearDirectory(String dir) async {
    try {
      if (!GetPlatform.isAndroid && !GetPlatform.isIOS) return ResponseModel();

      final Directory baseDir = await Helpers.getDirectory();

      final finalDir = Directory(join(baseDir.path, dir));

      if (finalDir.existsSync()) await finalDir.delete(recursive: true);

      return ResponseModel();
    } catch (e, s) {
      return ResponseModel(error: DefaultException(errorText: e.toString(), stackTrace: s));
    }
  }
}
