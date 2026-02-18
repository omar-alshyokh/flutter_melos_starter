import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/story.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/posts_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final PostsRepository _postsRepo;
  final FavoritesRepository _favoritesRepo;
  StreamSubscription<List<int>>? _favoritesSub;
  void _emitSafe(FavoritesState next) {
    if (!isClosed) emit(next);
  }

  FavoritesCubit(this._postsRepo, this._favoritesRepo)
    : super(const FavoritesState());

  Future<void> init() async {
    _emitSafe(state.copyWith(isLoading: true, clearErrorMessage: true));
    final ids = await _favoritesRepo.getIds();
    if (isClosed) return;
    await _loadStories(ids, isInitial: true);
    if (isClosed) return;

    _favoritesSub?.cancel();
    _favoritesSub = _favoritesRepo.watchIds().listen((next) {
      if (isClosed) return;
      _loadStories(next);
    });
  }

  Future<void> toggleFavorite(int id) => _favoritesRepo.toggle(id);

  Future<void> _loadStories(List<int> ids, {bool isInitial = false}) async {
    if (isClosed) return;
    if (ids.isEmpty) {
      _emitSafe(
        state.copyWith(
          items: const [],
          isLoading: false,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    if (!isInitial) {
      _emitSafe(state.copyWith(isLoading: true, clearErrorMessage: true));
    }

    final results = await Future.wait(ids.map(_postsRepo.getStory));
    if (isClosed) return;
    final stories = <Story>[];
    String? firstError;

    for (final result in results) {
      result.when(
        success: (story) => stories.add(story),
        failure: (f) => firstError ??= f.message,
      );
    }

    _emitSafe(
      state.copyWith(
        items: stories,
        isLoading: false,
        errorMessage: firstError,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _favoritesSub?.cancel();
    return super.close();
  }
}
