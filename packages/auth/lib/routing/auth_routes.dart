import 'package:auth/auth.dart';
import 'package:go_router/go_router.dart';

class AuthRoutes {
  static List<RouteBase> routes() => [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),
  ];
}
