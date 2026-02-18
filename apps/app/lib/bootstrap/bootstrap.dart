import 'package:app/mobile_app.dart';
import 'package:app/di/di.dart';
import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';

Future<void> bootstrap(Env env) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfigLoader.load(env);

  await configureDependencies(config: config);

  runApp(const MyApp());
}
