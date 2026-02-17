library auth_feature;

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

  static const label = 'Auth';
  static const icon = Icons.lock;


  static RouteBase route({
    required AuthCubit Function() cubitFactory,
  }) {
    return GoRoute(
      path: AuthRouteNames.path,
      name: AuthRouteNames.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => cubitFactory(),
          child: const LoginPage(),
        );
      },
      routes: [
        GoRoute(
          path: AuthRouteNames.registerPath,
          name: AuthRouteNames.register,
          builder: (context, state) {
            // reuse the same cubit instance from parent route
            return BlocProvider(
              create: (_) => cubitFactory(),
              child: const RegisterPage(),
            );
          },
        ),
        GoRoute(path: AuthRouteNames.profilePath, builder: (_, __) => const ProfilePage()),
        GoRoute(path: AuthRouteNames.changePasswordPath, builder: (_, __) => const ChangePasswordPage()),
        GoRoute(path: AuthRouteNames.changeEmailPath, builder: (_, __) => const ChangeEmailPage()),
      ],
    );
  }
}
