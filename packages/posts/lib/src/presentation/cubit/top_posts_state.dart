import 'package:equatable/equatable.dart';

import '../../domain/entities/story.dart';

class TopPostsState extends Equatable {
  final List<Story> items;
  final Set<int> favoriteIds;
  final bool isLoading;
  final String? errorMessage;

  const TopPostsState({
    this.items = const [],
    this.favoriteIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  TopPostsState copyWith({
    List<Story>? items,
    Set<int>? favoriteIds,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return TopPostsState(
      items: items ?? this.items,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [items, favoriteIds, isLoading, errorMessage];
}
