import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

class FeatureEntry {
  final String path;
  final String label;
  final IconData icon;
  final RouteBase? route;

  const FeatureEntry({
    required this.path,
    required this.label,
    required this.icon,
    this.route,
  });
}
