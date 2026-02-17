import 'dart:async';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration delay;

  RetryInterceptor({
    required this.dio,
    this.retries = 2,
    this.delay = const Duration(milliseconds: 400),
  });

  bool _shouldRetry(DioException e) {
    final type = e.type;
    final isNetwork = type == DioExceptionType.connectionError ||
        type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout;

    final isGet = e.requestOptions.method.toUpperCase() == 'GET';
    return isNetwork && isGet;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;
    if (attempt >= retries) {
      return handler.next(err);
    }

    err.requestOptions.extra['retry_attempt'] = attempt + 1;
    await Future<void>.delayed(delay);

    try {
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(e is DioException ? e : err);
    }
  }
}
