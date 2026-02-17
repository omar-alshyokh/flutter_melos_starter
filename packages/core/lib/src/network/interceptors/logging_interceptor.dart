import 'package:dio/dio.dart';
import '../../logging/log.dart';

class CoreLoggingInterceptor extends Interceptor {
  final bool logRequestBody;
  final bool logResponseBody;

  CoreLoggingInterceptor({
    this.logRequestBody = false,
    this.logResponseBody = false,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.d('→ ${options.method} ${options.uri}');
    if (logRequestBody && options.data != null) {
      Log.d('  body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.d('← ${response.statusCode} ${response.requestOptions.uri}');
    if (logResponseBody && response.data != null) {
      Log.d('  data: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e('✕ ${err.requestOptions.uri}', error: err);
    handler.next(err);
  }
}
