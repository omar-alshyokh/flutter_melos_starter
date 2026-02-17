import 'dart:async';

import 'package:app/di/di.dart';
import 'package:app/presentation/splash/splash_page.dart';
import 'package:app/presentation/shell/app_shell.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:more/more_feature.dart';
import 'package:posts/posts_feature.dart';

// (Optional) create Top/Favorites feature later, for now you can use placeholders
import 'package:app/presentation/placeholders/placeholder_page.dart';

class AppRouter {
  static const splashPath = '/splash';
  static const homeRedirectPath = PostsFeature.path; // '/home/posts'

  static GoRouter create() {
    final authCubit = getIt<AuthCubit>();

    return GoRouter(
      initialLocation: splashPath,

      // IMPORTANT: so redirect runs when auth state changes
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      redirect: (context, state) {
        final location = state.uri.path;

        final isSplash = location == splashPath;
        final isAuth = location == AuthRouteNames.path || location.startsWith('${AuthRouteNames.path}/');
        final isHome = location.startsWith('/home');

        final isLoggedIn = authCubit.state.user != null;

        // Splash: decide where to go (only once you know session state)
        if (isSplash) {
          // if you want: authCubit.loadSession() before leaving splash
          return isLoggedIn ? homeRedirectPath : AuthRouteNames.path;
        }

        // Not logged in -> force auth pages
        if (!isLoggedIn) {
          return isAuth ? null : AuthRouteNames.path;
        }

        // Logged in but still on auth -> push to home
        if (isLoggedIn && isAuth) {
          return homeRedirectPath;
        }

        // Logged in: allow /home routes
        if (isHome) return null;

        // Default fallback
        return homeRedirectPath;
      },

      routes: [
        GoRoute(
          path: splashPath,
          builder: (_, __) => const SplashPage(),
        ),

        // Auth OUTSIDE the shell
        AuthFeature.route(
          cubitFactory: () => getIt<AuthCubit>(),
        ),

        // Shell (logged-in area)
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            PostsFeature.route(), // /home/posts

            GoRoute(
              path: '/home/top',
              builder: (_, __) => const PlaceholderPage(title: 'Top Posts'),
            ),

            GoRoute(
              path: '/home/favorites',
              builder: (_, __) => const PlaceholderPage(title: 'Favorites'),
            ),

            MoreFeature.route(), // /home/more (make it consistent)
          ],
        ),
      ],
    );
  }
}

/// Minimal helper: converts a Stream into a Listenable for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
