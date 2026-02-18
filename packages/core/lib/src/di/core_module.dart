import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/app_prefs.dart';
import '../storage/secure_store.dart';

class CoreModule {
  static Future<SharedPreferences> sharedPrefs() =>
      SharedPreferences.getInstance();

  static FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  static AppPrefs appPrefs(SharedPreferences prefs) => AppPrefs(prefs);

  static SecureStore secureStore(FlutterSecureStorage storage) =>
      SecureStore(storage);
}
