import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

typedef FeatureRouteFactory = RouteBase Function();

class FeatureEntry {
  final String path;
  final String label;
  final IconData icon;
  final FeatureRouteFactory routeFactory;

  FeatureEntry({
    required this.path,
    required this.label,
    required this.icon,
    required this.routeFactory,
  });

  RouteBase buildRoute() => routeFactory();
}
