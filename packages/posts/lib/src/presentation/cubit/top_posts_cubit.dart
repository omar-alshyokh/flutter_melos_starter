import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/story.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/posts_repository.dart';
import 'top_posts_state.dart';

class TopPostsCubit extends Cubit<TopPostsState> {
  final PostsRepository _postsRepo;
  final FavoritesRepository _favoritesRepo;
  final int _fetchCount;

  StreamSubscription<List<int>>? _favoritesSub;
  void _emitSafe(TopPostsState next) {
    if (!isClosed) emit(next);
  }

  TopPostsCubit(this._postsRepo, this._favoritesRepo, {int fetchCount = 100})
    : _fetchCount = fetchCount,
      super(const TopPostsState());

  Future<void> init() async {
    final ids = await _favoritesRepo.getIds();
    if (isClosed) return;
    _emitSafe(state.copyWith(favoriteIds: ids.toSet()));

    _favoritesSub?.cancel();
    _favoritesSub = _favoritesRepo.watchIds().listen((next) {
      if (isClosed) return;
      _emitSafe(state.copyWith(favoriteIds: next.toSet()));
    });
  }

  Future<void> load() async {
    _emitSafe(state.copyWith(isLoading: true, clearErrorMessage: true));

    final res = await _postsRepo.getTopStoriesPage(
      page: 0,
      pageSize: _fetchCount,
    );
    if (isClosed) return;

    res.when(
      success: (list) {
        final sorted = List<Story>.from(list)
          ..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
        _emitSafe(state.copyWith(items: sorted, isLoading: false));
      },
      failure: (f) {
        _emitSafe(state.copyWith(isLoading: false, errorMessage: f.message));
      },
    );
  }

  Future<void> refresh() async {
    _postsRepo.reset();
    await load();
  }

  Future<void> toggleFavorite(int id) => _favoritesRepo.toggle(id);

  @override
  Future<void> close() async {
    await _favoritesSub?.cancel();
    return super.close();
  }
}
