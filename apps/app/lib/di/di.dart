import 'package:app_config/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';
import 'package:posts/posts_di.dart' as posts_di;
import 'package:auth/auth.dart' as auth_di;
import 'package:more/more.dart' as more_di;

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({required AppConfig config}) async {
  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerSingleton<AppConfig>(config);
  }

  // App-level Injectable modules only (like NetworkModule)
  getIt.init();

  // feature DI
  auth_di.configureAuthDependencies(getIt);
  posts_di.configurePostsDependencies(getIt);
  more_di.configureMoreDependencies(getIt);

}

