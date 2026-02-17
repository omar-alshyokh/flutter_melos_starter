import 'package:app/di/di.dart';
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'src/presentation/cubit/more_cubit.dart';
import 'src/presentation/pages/more_page.dart';

class MoreFeature {
  static const path = '/home/more';
  static const label = 'More';
  static const icon = Icons.more_horiz;

  static GoRoute route() => GoRoute(
    path: path,
    builder: (context, state) => BlocProvider(
      create: (_) => getIt<MoreCubit>(),
      child: MorePage(
        onOpenProfile: () => context.push(AuthRouteNames.profilePath),
        onOpenChangePassword: () => context.push(AuthRouteNames.changePasswordPath),
        onOpenChangeEmail: () => context.push(AuthRouteNames.changeEmailPath),
      ),
    ),
  );
}
