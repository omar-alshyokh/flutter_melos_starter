import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:posts/posts.dart';
import 'package:auth/auth.dart';

import '../di/di.dart';
import 'app_shell.dart';

GoRouter createRouter() {
  final routes = <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        ...AuthRoutes.routes(),

        ...PostsRoutes.routes(
          pageBuilder: () => BlocProvider(
            create: (_) => getIt<PostsCubit>()..load(limit: 20),
            child: const PostsPage(),
          ),
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: '/posts',
    routes: routes,
  );
}
