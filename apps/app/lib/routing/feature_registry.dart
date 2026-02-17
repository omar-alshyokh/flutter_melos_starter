import 'package:app/routing/feature_entry.dart';
import 'package:more/more_feature.dart';
import 'package:posts/posts_feature.dart';
import 'package:flutter/material.dart';

List<FeatureEntry> featureRegistry() => [
  FeatureEntry(
    path: PostsFeature.path,
    label: PostsFeature.label,
    icon: PostsFeature.icon,
    route: PostsFeature.route(),
  ),
  const FeatureEntry(
    path: '/home/top',
    label: 'Top',
    icon: Icons.trending_up,
    route: null, // route already in router
  ),
  const FeatureEntry(
    path: '/home/favorites',
    label: 'Favorites',
    icon: Icons.favorite,
    route: null,
  ),
  FeatureEntry(
    path: MoreFeature.path,
    label: MoreFeature.label,
    icon: MoreFeature.icon,
    route: MoreFeature.route(),
  ),
];
