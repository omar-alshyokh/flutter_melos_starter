import 'package:app/routing/feature_entry.dart';
import 'package:flutter/material.dart';
import 'package:more/more.dart';
import 'package:posts/posts.dart';
import 'package:posts/posts_feature.dart';

List<FeatureEntry> featureRegistry({
  required String postsPath,
  required String topPath,
  required String favoritesPath,
  required String morePath,
  required PostsCubit Function() postsCubitFactory,
  required TopPostsCubit Function() topPostsCubitFactory,
  required FavoritesCubit Function() favoritesCubitFactory,
  required PostDetailsCubit Function() postDetailsCubitFactory,
  required MoreCubit Function() moreCubitFactory,
  required void Function(BuildContext ctx) onOpenProfile,
  required void Function(BuildContext ctx) onOpenChangePassword,
  required void Function(BuildContext ctx) onOpenChangeEmail,
}) => [
  FeatureEntry(
    path: postsPath,
    label: PostsFeature.postsLabel,
    icon: PostsFeature.postsIcon,
    routeFactory: () => PostsFeature.route(
      path: postsPath,
      postsCubitFactory: postsCubitFactory,
      postDetailsCubitFactory: postDetailsCubitFactory,
    ),
  ),
  FeatureEntry(
    path: topPath,
    label: PostsFeature.topLabel,
    icon: PostsFeature.topIcon,
    routeFactory: () => PostsFeature.topRoute(
      path: topPath,
      topPostsCubitFactory: topPostsCubitFactory,
    ),
  ),
  FeatureEntry(
    path: favoritesPath,
    label: PostsFeature.favoritesLabel,
    icon: PostsFeature.favoritesIcon,
    routeFactory: () => PostsFeature.favoritesRoute(
      path: favoritesPath,
      favoritesCubitFactory: favoritesCubitFactory,
    ),
  ),
  FeatureEntry(
    path: morePath,
    label: MoreFeature.label,
    icon: MoreFeature.icon,
    routeFactory: () => MoreFeature.route(
      path: morePath,
      cubitFactory: moreCubitFactory,
      onOpenProfile: onOpenProfile,
      onOpenChangePassword: onOpenChangePassword,
      onOpenChangeEmail: onOpenChangeEmail,
    ),
  ),
];
