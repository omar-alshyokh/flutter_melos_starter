import 'package:core/core.dart';
import 'package:dio/dio.dart';
import '../logging/log.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/headers_interceptor.dart';

class DioFactory {
  static Dio create({
    required String baseUrl,
    bool enableLogs = false,
    bool enableRetry = false,
    HeaderProvider? headerProvider,
    Duration connectTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    Log.enabled = enableLogs;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        responseType: ResponseType.json,
      ),
    );

    if (headerProvider != null) {
      dio.interceptors.add(HeadersInterceptor(headerProvider));
    }

    if (enableLogs) {
      // dio.interceptors.add(CoreLoggingInterceptor());
      dio.interceptors.add(
        NetworkLoggerInterceptor(
          enabled: enableLogs,
          logHeaders: false,
          logResponseBody: false,
        ),
      );
    }

    if (enableRetry) {
      dio.interceptors.add(RetryInterceptor(dio: dio));
    }

    return dio;
  }
}
