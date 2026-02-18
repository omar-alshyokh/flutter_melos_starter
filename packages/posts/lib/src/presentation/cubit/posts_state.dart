import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

class PostsState extends Equatable {
  final List<Story> items;
  final Set<int> favoriteIds;

  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isLoadingMore;

  final bool hasMore;
  final String? errorMessage; // for initial load errors
  final String? loadMoreErrorMessage; // for load-more errors (non-blocking)

  const PostsState({
    this.items = const [],
    this.favoriteIds = const {},
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.loadMoreErrorMessage,
  });

  PostsState copyWith({
    List<Story>? items,
    Set<int>? favoriteIds,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    String? loadMoreErrorMessage,
    bool clearErrorMessage = false,
    bool clearLoadMoreErrorMessage = false,
  }) {
    return PostsState(
      items: items ?? this.items,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      loadMoreErrorMessage: clearLoadMoreErrorMessage
          ? null
          : (loadMoreErrorMessage ?? this.loadMoreErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    items,
    favoriteIds,
    isInitialLoading,
    isRefreshing,
    isLoadingMore,
    hasMore,
    errorMessage,
    loadMoreErrorMessage,
  ];
}
