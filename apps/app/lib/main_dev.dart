import 'package:app/app.dart';
import 'package:app/di/di.dart';
import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(config: AppConfigs.dev);
  runApp(MyApp());
}
