import 'dart:developer';
import 'package:dio/dio.dart';

class NetworkLoggerInterceptor extends Interceptor {
  final bool enabled;
  final bool logHeaders;
  final bool logResponseBody;

  NetworkLoggerInterceptor({
    required this.enabled,
    this.logHeaders = false,
    this.logResponseBody = false,
  });

  final _startTimes = <int, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) return handler.next(options);

    _startTimes[options.hashCode] = DateTime.now();

    final path =
        options.uri.path +
        (options.uri.hasQuery ? '?${options.uri.query}' : '');
    log('➡️ ${options.method} $path');

    if (logHeaders && options.headers.isNotEmpty) {
      log('headers: ${options.headers}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) return handler.next(response);

    final start = _startTimes.remove(response.requestOptions.hashCode);
    final ms = start == null
        ? null
        : DateTime.now().difference(start).inMilliseconds;

    final path = response.requestOptions.uri.path;
    final code = response.statusCode ?? 0;

    log(
      '✅ ${response.requestOptions.method} $path $code${ms == null ? '' : ' (${ms}ms)'}',
    );

    if (logHeaders && response.headers.map.isNotEmpty) {
      log('resp-headers: ${response.headers.map}');
    }

    if (logResponseBody) {
      log('body: ${response.data}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) return handler.next(err);

    final start = _startTimes.remove(err.requestOptions.hashCode);
    final ms = start == null
        ? null
        : DateTime.now().difference(start).inMilliseconds;

    final path = err.requestOptions.uri.path;
    final msg = err.message ?? err.type.name;

    log(
      '❌ ${err.requestOptions.method} $path ($msg)${ms == null ? '' : ' (${ms}ms)'}',
    );

    handler.next(err);
  }
}
