import 'env.dart';

class AppConfig {
  final Env env;

  /// API base url (can be used by Dio baseUrl)
  final String baseUrl;

  /// Networking
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Logging / debug switches
  final bool enableNetworkLogs;

  /// Optional build info (nice for banners, support logs)
  final String? versionName;
  final String? buildNumber;

  const AppConfig({
    required this.env,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableNetworkLogs,
    this.versionName,
    this.buildNumber,
  });

  bool get isProd => env == Env.prod;
}
