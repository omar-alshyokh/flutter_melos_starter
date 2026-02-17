import 'app_config.dart';
import 'env.dart';

class AppConfigLoader {
  static AppConfig load(
      Env env, {
        String? baseUrlOverride,
        String? versionName,
        String? buildNumber,
      }) {
    final baseUrl = baseUrlOverride ?? _defaultBaseUrl(env);

    return AppConfig(
      env: env,
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      enableNetworkLogs: _enableNetworkLogs(env),
      versionName: versionName,
      buildNumber: buildNumber,
    );
  }

  static String _defaultBaseUrl(Env env) {
    // Keep generic defaults. For this starter we point to HN.
    // When you start a new project, you only change here or pass override.
    return switch (env) {
      Env.dev => 'https://hacker-news.firebaseio.com/v0',
      Env.stage => 'https://hacker-news.firebaseio.com/v0',
      Env.prod => 'https://hacker-news.firebaseio.com/v0',
    };
  }

  static bool _enableNetworkLogs(Env env) {
    return switch (env) {
      Env.dev => true,
      Env.stage => true,
      Env.prod => false,
    };
  }
}
