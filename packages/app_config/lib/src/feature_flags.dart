class FeatureFlags {
  final bool enableNetworkLogs;
  final bool enableCrashReporting;
  final bool enablePerformanceTracking;
  final bool enableLogs;

  const FeatureFlags({
    required this.enableLogs,
    required this.enableNetworkLogs,
    required this.enableCrashReporting,
    required this.enablePerformanceTracking,
  });

  factory FeatureFlags.dev() => const FeatureFlags(
    enableLogs: true,
    enableNetworkLogs: true,
    enableCrashReporting: false,
    enablePerformanceTracking: false,
  );

  factory FeatureFlags.stage() => const FeatureFlags(
    enableLogs: true,
    enableNetworkLogs: true,
    enableCrashReporting: true,
    enablePerformanceTracking: true,
  );

  factory FeatureFlags.prod() => const FeatureFlags(
    enableLogs: false,
    enableNetworkLogs: false,
    enableCrashReporting: true,
    enablePerformanceTracking: true,
  );
}
