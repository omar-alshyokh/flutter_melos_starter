import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:posts/posts.dart';
import 'package:posts/src/presentation/pages/post_details_page.dart';
import 'package:posts/src/presentation/routes/posts_route_names.dart';

class PostsFeature {
  static const postsLabel = 'Posts';
  static const postsIcon = Icons.list;
  static const topLabel = 'Top';
  static const topIcon = Icons.trending_up;
  static const favoritesLabel = 'Favorites';
  static const favoritesIcon = Icons.favorite;

  static RouteBase route({
    required String path,
    required PostsCubit Function() postsCubitFactory,
    required PostDetailsCubit Function() postDetailsCubitFactory,
  }) {
    return GoRoute(
      path: path,
      name: PostsRouteNames.posts,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => postsCubitFactory(),
          child: const PostsPage(),
        );
      },
      routes: [
        GoRoute(
          path: PostsRouteNames.detailsPathSegment,
          name: PostsRouteNames.postDetails,
          builder: (context, state) {
            final idStr = state.pathParameters['id'];
            final id = int.tryParse(idStr ?? '') ?? 0;

            return BlocProvider(
              create: (_) => postDetailsCubitFactory()..load(id),
              child: PostDetailsPage(id: id),
            );
          },
        ),
      ],
    );
  }

  static RouteBase topRoute({
    required String path,
    required TopPostsCubit Function() topPostsCubitFactory,
  }) {
    return GoRoute(
      path: path,
      name: PostsRouteNames.topPosts,
      builder: (_, __) => BlocProvider(
        create: (_) => topPostsCubitFactory(),
        child: const TopPostsPage(),
      ),
    );
  }

  static RouteBase favoritesRoute({
    required String path,
    required FavoritesCubit Function() favoritesCubitFactory,
  }) {
    return GoRoute(
      path: path,
      name: PostsRouteNames.favoritePosts,
      builder: (_, __) => BlocProvider(
        create: (_) => favoritesCubitFactory(),
        child: const FavoritesPage(),
      ),
    );
  }
}
