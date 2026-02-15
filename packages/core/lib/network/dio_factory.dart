import 'package:dio/dio.dart';

class DioFactory {
  static Dio create({
    required String baseUrl,
    required bool enableLogs,
    Map<String, String>? headers,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: headers,
      ),
    );

    // Retry once on timeout
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          final isTimeout = e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout;

          final alreadyRetried = e.requestOptions.extra['__retried__'] == true;

          if (isTimeout && !alreadyRetried) {
            try {
              final opts = e.requestOptions;
              opts.extra['__retried__'] = true;
              final res = await dio.fetch(opts);
              return handler.resolve(res);
            } catch (_) {
              // fall through
            }
          }
          return handler.next(e);
        },
      ),
    );

    if (enableLogs) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: false),
      );
    }

    return dio;
  }
}
