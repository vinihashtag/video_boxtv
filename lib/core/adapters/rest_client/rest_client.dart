import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../data/models/response_model.dart';
import '../../utils/app_exceptions.dart';
import '../../utils/helpers.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/pretty_log_interceptor.dart';
import 'rest_client_adatper.dart';

class RestClientAdapter implements IRestClientAdapter {
  RestClientAdapter({bool requestByIsolate = false, bool getCurlRequestOnSuccess = false}) {
    _dio = Dio(
      BaseOptions(
          connectTimeout: 30000,
          receiveTimeout: 90000,
          baseUrl: '' //_requestByIsolate ? '' : Environment.getString('apiBaseUrl'),
          ),
    );

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  late Dio _dio;

  @override
  Future<ResponseModel> request(
      {required String url,
      required MethodRequest method,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      dynamic data,
      dynamic cancelToken,
      void Function(int p1, int p2)? updateProgress,
      void Function(int p1, int p2)? downloadProgress,
      String? pathWillSaved,
      Duration? validateCache}) async {
    final defaultHeaders = headers ?? {};

    _dio.interceptors.clear();

    try {
      if (method == MethodRequest.download) {
        final Response response = await _dio.get(
          url,
          options: Options(responseType: ResponseType.bytes, followRedirects: false),
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: downloadProgress,
        );

        return ResponseModel(data: response.data, statusCode: response.statusCode);
      }

      _dio.interceptors.addAll([
        AuthInterceptor(requestByIsolate: false),
        if (kDebugMode) CustomLogInterceptor(logPrint: Helpers.debug),
      ]);

      // if (validateCache != null && !_requestByIsolate) {
      //   _dio.interceptors.add(CacheInterceptor(maxValidateCache: validateCache));
      // }

      final Response response = await _dio.request(
        /// If the `path` starts with 'http(s)', the `baseURL` will be ignored, otherwise,
        /// it will be combined and then resolved with the baseUrl.
        url,
        data: data,
        options: Options(headers: defaultHeaders, method: method.name.toUpperCase()),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: updateProgress,
        onReceiveProgress: downloadProgress,
      );

      return ResponseModel(data: response.data, statusCode: response.statusCode);
    } on DioError catch (e, s) {
      if (method == MethodRequest.download) {
        return ResponseModel(error: Exception('Erro ao fazer download'));
      }

      return ResponseModel(error: handleError(e, s));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Failure handleError(dynamic error, StackTrace stackTrace) {
    if (error is DioError) {
      if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.receiveTimeout ||
          error.type == DioErrorType.sendTimeout) {
        return TimeoutException(stackTrace: stackTrace);
      }

      if (error.type == DioErrorType.other) {
        if (error.message.contains('SocketException')) {
          return ServerException(stackTrace: stackTrace);
        }
      }

      if (error.type == DioErrorType.response) {
        final int statusCode = error.response?.statusCode ?? -1;

        if (statusCode == 404) return NotFoundException(stackTrace: stackTrace);

        if (statusCode >= 500) return ServerException(stackTrace: stackTrace);

        if (error.response != null) {
          return DefaultException(errorText: error.response?.data?["message"], stackTrace: stackTrace);
        }
      }

      return DefaultException(stackTrace: stackTrace, errorText: 'Erro inesperado: ${error.message}');
    }

    if (error is Failure && error is! DefaultException) return error;

    return DefaultException(stackTrace: stackTrace);
  }

  static String getCurlRequest(RequestOptions options) {
    try {
      List<String> components = ['curl -i'];

      // Method
      if (options.method.toUpperCase() != 'GET') {
        components.add('-X ${options.method}');
      }

      // Headers
      options.headers.forEach((k, v) {
        if (k != 'Cookie') {
          components.add('-H "$k: $v"');
        }
      });

      // Data
      if (options.data != null) {
        // FormData can't be JSON-serialized, so keep only their fields attributes
        if (options.data is FormData) {
          options.data = Map.fromEntries(options.data.fields);
        }

        final data = json.encode(options.data).replaceAll('"', '\\"');
        components.add('-d "$data"');
      }

      // URL
      components.add('"${options.uri.toString()}"');

      final result = components.join(' ');

      return result;
    } catch (e, s) {
      Helpers.error(identifier: '[RestClient][getCurlRequest]', e, s);
      return '';
    }
  }

  static List<String> dataToList(dynamic data) {
    final result = <String>[];

    if (data != null) {
      if (data is FormData) {
        // Fields

        for (final field in data.fields) {
          result.add('--form "${field.key}=${field.value}"');
        }

        // Files references
        for (final file in data.files) {
          result.add('-F "${file.key}=@${file.value.filename}"');
        }
      } else if (data is Map) {
        final payload = json.encode(data).replaceAll('"', '\\"');
        result.add('-d "$payload');
      }
    }
    return result;
  }

  @override
  void close() => _dio.close(force: true);
}
