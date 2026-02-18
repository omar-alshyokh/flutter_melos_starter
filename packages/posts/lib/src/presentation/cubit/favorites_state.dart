import 'package:equatable/equatable.dart';

import '../../domain/entities/story.dart';

class FavoritesState extends Equatable {
  final List<Story> items;
  final bool isLoading;
  final String? errorMessage;

  const FavoritesState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FavoritesState copyWith({
    List<Story>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FavoritesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [items, isLoading, errorMessage];
}
