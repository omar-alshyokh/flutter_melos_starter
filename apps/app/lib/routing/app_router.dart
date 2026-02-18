import 'dart:async';

import 'package:app/di/di.dart';
import 'package:app/presentation/splash/splash_page.dart';
import 'package:app/presentation/shell/app_shell.dart';
import 'package:app/routing/feature_registry.dart';
import 'package:app/routing/route_paths.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:more/more.dart';
import 'package:posts/posts.dart';

class AppRouter {
  static const splashPath = RoutePaths.splash;
  static const homeRedirectPath = RoutePaths.posts;

  static GoRouter create() {
    final authCubit = getIt<AuthCubit>();
    final shellFeatures = featureRegistry(
      postsPath: RoutePaths.posts,
      topPath: RoutePaths.top,
      favoritesPath: RoutePaths.favorites,
      morePath: RoutePaths.more,
      postsCubitFactory: () => getIt<PostsCubit>(),
      topPostsCubitFactory: () => getIt<TopPostsCubit>(),
      favoritesCubitFactory: () => getIt<FavoritesCubit>(),
      postDetailsCubitFactory: () => getIt<PostDetailsCubit>(),
      moreCubitFactory: () => getIt<MoreCubit>(),
      onOpenProfile: (ctx) => ctx.pushNamed(AuthRouteNames.profileName),
      onOpenChangePassword: (ctx) =>
          ctx.pushNamed(AuthRouteNames.changePasswordName),
      onOpenChangeEmail: (ctx) => ctx.pushNamed(AuthRouteNames.changeEmailName),
    );

    return GoRouter(
      initialLocation: splashPath,

      // IMPORTANT: so redirect runs when auth state changes
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      redirect: (context, state) {
        final location = state.uri.path;

        final isSplash = location == splashPath;

        // public auth only
        final isAuthLoginOrRegister =
            location == RoutePaths.authLogin ||
            location == RoutePaths.authRegister;

        final isLoggedIn = authCubit.state.user != null;

        if (isSplash) {
          return isLoggedIn ? homeRedirectPath : RoutePaths.authLogin;
        }

        if (!isLoggedIn) {
          // allow only login/register if not logged in
          return isAuthLoginOrRegister ? null : RoutePaths.authLogin;
        }

        // logged in: prevent going back to login/register
        if (isLoggedIn && isAuthLoginOrRegister) {
          return homeRedirectPath;
        }

        return null;
      },

      routes: [
        GoRoute(path: splashPath, builder: (_, __) => const SplashPage()),

        // Auth OUTSIDE the shell
        AuthFeature.publicRoutes(
          path: RoutePaths.authBase,
          cubitFactory: () => getIt<AuthCubit>(),
        ),

        // Shell (logged-in area)
        ShellRoute(
          builder: (context, state, child) =>
              AppShell(items: shellFeatures, child: child),
          routes: [
            ...shellFeatures.map((entry) => entry.buildRoute()),

            // auth account routes INSIDE shell
            ...AuthFeature.accountRoutes(
              basePath: RoutePaths.accountBase,
              cubitFactory: () => getIt<AuthCubit>(),
            ),
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
