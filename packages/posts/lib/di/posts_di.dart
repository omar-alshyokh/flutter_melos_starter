import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'posts_di.config.dart';

@InjectableInit(
  initializerName: 'initPosts',
  asExtension: true,
)
void configurePostsDI(GetIt getIt) => getIt.initPosts();
