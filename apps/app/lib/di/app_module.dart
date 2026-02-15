import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @lazySingleton
  DateTime get now => DateTime.now();
}
