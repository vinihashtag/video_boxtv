import 'package:dio/dio.dart';

class CacheInterceptor extends QueuedInterceptorsWrapper {
  final Duration maxValidateCache;

  CacheInterceptor({required this.maxValidateCache});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // try {
    //   final cacheRepository = Modular.get<ILocalCacheRepository>();
    //   final cache = await cacheRepository.getCacheByUrl(options.uri.toString());
    //   if (cache != null) {
    //     final dateNow = DateTime.now();
    //     final diference = dateNow.difference(cache.lastRequest);

    //     // ? if value of comparation is less or equal zero, cache is valid
    //     final cacheIsValid = diference.compareTo(maxValidateCache) <= 0;
    //     // debug('Cache is valid: $cacheIsValid');

    //     // ? if response don`t expired, return this or lost connection try get in cache
    //     if (cacheIsValid) {
    //       // debug('RESPONSE BY CACHE: Status: 200 OK');
    //       // debug('URL: ${options.uri}');
    //       return handler.resolve(
    //         Response(
    //           data: json.decode(cache.response),
    //           statusCode: 200,
    //           requestOptions: options,
    //         ),
    //       );
    //     }
    //   }
    // } catch (e, s) {
    //   error('Error on request of cache interceptor', e, s);
    // }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    // try {
    //   bool hasResponse = true;

    //   // ? don`t save in cache requests where haven`t content
    //   if (response.data == null) hasResponse = false;
    //   if (response.data is List && (response.data as List).isEmpty) hasResponse = false;
    //   if (response.data is Map && (response.data as Map).isEmpty) hasResponse = false;
    //   if (!hasResponse) return super.onResponse(response, handler);

    //   final key = response.requestOptions.uri.toString();

    //   final cacheRepository = Modular.get<ILocalCacheRepository>();
    //   final cache = await cacheRepository.getCacheByUrl(key);

    //   if (cache != null) {
    //     cache.lastRequest = DateTime.now();
    //     cache.response = json.encode(response.data);

    //     await cacheRepository.saveCache(cache);
    //     // debug('UPDATE REQUEST CACHED: $key');
    //   } else {
    //     final cache = CacheEntity(
    //       url: key,
    //       response: json.encode(response.data),
    //       lastRequest: DateTime.now(),
    //     );

    //     await cacheRepository.saveCache(cache);
    //     // debug('REQUEST CACHED: $key');
    //   }
    // } catch (e) {
    //   error('Erro no Response Cache: $e');
    // }

    return super.onResponse(response, handler);
  }
}
