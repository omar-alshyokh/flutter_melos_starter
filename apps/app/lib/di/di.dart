import 'package:app_config/app_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:posts/di/posts_di.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({required AppConfig config}) async {
  getIt.registerSingleton<AppConfig>(config);
  configurePostsDI(getIt);
  getIt.init();
}



