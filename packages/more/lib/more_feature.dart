import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:more/more.dart';
import 'package:more/src/presentation/pages/about_app_page.dart';
import 'package:more/src/routing/more_route_names.dart';
import 'src/presentation/pages/more_page.dart';

class MoreFeature {
  static const label = 'More';
  static const icon = Icons.more_horiz;

  static GoRoute route({
    required String path,
    required MoreCubit Function() cubitFactory,
    required void Function(BuildContext ctx) onOpenProfile,
    required void Function(BuildContext ctx) onOpenChangePassword,
    required void Function(BuildContext ctx) onOpenChangeEmail,
  }) {
    return GoRoute(
      path: path,
      builder: (context, state) => BlocProvider(
        create: (_) => cubitFactory(),
        child: MorePage(
          onOpenProfile: () => onOpenProfile(context),
          onOpenChangePassword: () => onOpenChangePassword(context),
          onOpenChangeEmail: () => onOpenChangeEmail(context),
        ),
      ),
      routes: [
        GoRoute(
          path: MoreRouteNames.aboutSegment,
          name: MoreRouteNames.aboutName,
          builder: (_, __) => const AboutAppPage(),
        ),
      ],
    );
  }
}
