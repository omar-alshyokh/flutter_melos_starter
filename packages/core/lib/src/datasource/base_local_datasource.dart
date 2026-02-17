import '../storage/app_prefs.dart';
import '../storage/secure_store.dart';

abstract class BaseLocalDataSource {
  final AppPrefs prefs;
  final SecureStore secure;

  BaseLocalDataSource(this.prefs, this.secure);
}
