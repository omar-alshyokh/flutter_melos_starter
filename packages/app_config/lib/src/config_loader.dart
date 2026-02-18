import 'app_config.dart';
import 'env.dart';

class ConfigLoader {
  static AppConfig load({
    required Env env,
    required String apiBaseUrl,
    required bool enableNetworkLogs,
    String? versionName,
    String? buildNumber,
  }) {
    return AppConfig(
      env: env,
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      versionName: versionName,
      buildNumber: buildNumber,
      enableNetworkLogs: enableNetworkLogs,
    );
  }
}
