import 'package:auth/src/presentation/pages/change_email_page.dart';
import 'package:auth/src/presentation/pages/change_password_page.dart';
import 'package:auth/src/presentation/pages/profile_page.dart';
import 'package:auth/src/routing/auth_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'src/presentation/cubit/auth_cubit.dart';
import 'src/presentation/pages/login_page.dart';
import 'src/presentation/pages/register_page.dart';

class AuthFeature {
  static const icon = Icons.lock;

  /// Public auth routes (OUTSIDE shell)
  static RouteBase publicRoutes({
    required String path,
    required AuthCubit Function() cubitFactory,
  }) {
    return GoRoute(
      path: path,
      redirect: (_, __) => '$path/${AuthRouteNames.loginSegment}',
      routes: [
        GoRoute(
          path: AuthRouteNames.loginSegment,
          name: AuthRouteNames.loginName,
          builder: (ctx, st) => BlocProvider(
            create: (_) => cubitFactory(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AuthRouteNames.registerSegment,
          name: AuthRouteNames.registerName,
          builder: (ctx, st) => BlocProvider(
            create: (_) => cubitFactory(),
            child: const RegisterPage(),
          ),
        ),
      ],
    );
  }

  /// Account routes (INSIDE shell)
  static List<RouteBase> accountRoutes({
    required String basePath,
    required AuthCubit Function() cubitFactory,
  }) {
    return [
      GoRoute(
        path: '$basePath/${AuthRouteNames.profileSegment}',
        name: AuthRouteNames.profileName,
        builder: (ctx, st) => BlocProvider(
          create: (_) => cubitFactory(),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: '$basePath/${AuthRouteNames.changePasswordSegment}',
        name: AuthRouteNames.changePasswordName,
        builder: (ctx, st) => BlocProvider(
          create: (_) => cubitFactory(),
          child: const ChangePasswordPage(),
        ),
      ),
      GoRoute(
        path: '$basePath/${AuthRouteNames.changeEmailSegment}',
        name: AuthRouteNames.changeEmailName,
        builder: (ctx, st) => BlocProvider(
          create: (_) => cubitFactory(),
          child: const ChangeEmailPage(),
        ),
      ),
    ];
  }
}
