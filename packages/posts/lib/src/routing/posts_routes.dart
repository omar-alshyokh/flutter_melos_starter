import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostsRoutes {
  static List<RouteBase> routes({required Widget Function() pageBuilder}) => [
    GoRoute(path: '/posts', builder: (context, state) => pageBuilder()),
  ];
}
