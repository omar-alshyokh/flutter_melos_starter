import 'package:app/bootstrap/bootstrap.dart';
import 'package:app_config/app_config.dart';

Future<void> main() async {
  await bootstrap(Env.dev);
}
