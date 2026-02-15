class AppConfig {
  final String appName;
  final String baseUrl;
  final bool enableLogs;

  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.enableLogs,
  });
}

enum Environment { dev, staging, prod }

class AppConfigs {
  static const dev = AppConfig(
    appName: 'Starter (Dev)',
    baseUrl: 'https://hacker-news.firebaseio.com/v0',
    enableLogs: true,
  );

  static const staging = AppConfig(
    appName: 'Starter (Staging)',
    baseUrl: 'https://hacker-news.firebaseio.com/v0',
    enableLogs: true,
  );

  static const prod = AppConfig(
    appName: 'Starter',
    baseUrl: 'https://hacker-news.firebaseio.com/v0',
    enableLogs: false,
  );
}
