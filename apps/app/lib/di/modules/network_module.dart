import 'package:app_config/app_config.dart';
import 'package:core/core_di.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final config = GetIt.I<AppConfig>();

    return DioFactory.create(
      baseUrl: config.baseUrl,
      enableLogs: config.enableNetworkLogs,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
    );
  }
}
