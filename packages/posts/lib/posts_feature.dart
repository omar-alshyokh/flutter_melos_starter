library posts_feature;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:posts/posts.dart'; // exports cubits/pages OR adjust imports to your actual exports
import 'package:posts/src/presentation/pages/post_details_page.dart';
import 'package:posts/src/presentation/routes/posts_route_names.dart'; // optional if you keep names, otherwise remove

/// Feature owns: Cubit creation + initial load + details cubit
/// App owns only: tabs + shell + router composition
class PostsFeature {
  static const path = '/home/posts';
  static const label = 'Posts';
  static const icon = Icons.list;

  // Expose details page if you want to keep page inside package public API
  static Widget detailsPage(int id) => PostDetailsPage(id: id);

  /// Feature-level route (no params from app)
  static RouteBase route() {
    return GoRoute(
      path: path,
      // Optional but recommended: use name if you navigate by name
      name: PostsRouteNames.posts,
      builder: (context, state) {
        return BlocProvider(
          // If you use GetIt inside posts: create: (_) => GetIt.I<PostsCubit>()..loadInitial(),
          // Or create directly (shown):
          create: (_) => GetIt.I<PostsCubit>()..loadInitial(),
          child: const PostsPage(),
        );
      },
      routes: [
        GoRoute(
          path: 'details/:id',
          name: PostsRouteNames.postDetails,
          builder: (context, state) {
            final idStr = state.pathParameters['id'];
            final id = int.tryParse(idStr ?? '') ?? 0;

            return BlocProvider(
              // If you use GetIt inside posts: create: (_) => GetIt.I<PostDetailsCubit>()..load(id),
              // Or create directly (shown):
              create: (_) => GetIt.I<PostDetailsCubit>()..load(id),
              child: PostDetailsPage(id: id),
            );
          },
        ),
      ],
    );
  }
}
