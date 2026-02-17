import 'package:dio/dio.dart';

typedef HeaderProvider = Future<Map<String, String>> Function();

class HeadersInterceptor extends Interceptor {
  final HeaderProvider provider;
  HeadersInterceptor(this.provider);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final headers = await provider();
    options.headers.addAll(headers);
    handler.next(options);
  }
}
