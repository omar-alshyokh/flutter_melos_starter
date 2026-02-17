import 'package:flutter/foundation.dart';

class Log {
  static bool enabled = kDebugMode;

  static void d(Object msg) {
    if (enabled) debugPrint('[D] $msg');
  }

  static void i(Object msg) {
    if (enabled) debugPrint('[I] $msg');
  }

  static void e(Object msg, {Object? error, StackTrace? stack}) {
    if (!enabled) return;
    debugPrint('[E] $msg');
    if (error != null) debugPrint('  error: $error');
    if (stack != null) debugPrint('  stack: $stack');
  }
}
