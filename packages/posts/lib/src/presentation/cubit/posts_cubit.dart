import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/posts_repository.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepository _repo;
  final FavoritesRepository _favoritesRepo;

  // keep paging inside cubit
  final int _pageSize;
  int _page = 0;
  StreamSubscription<List<int>>? _favoritesSub;
  void _emitSafe(PostsState next) {
    if (!isClosed) emit(next);
  }

  PostsCubit(this._repo, this._favoritesRepo, {int pageSize = 20})
    : _pageSize = pageSize,
      super(const PostsState());

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

  Future<void> toggleFavorite(int id) => _favoritesRepo.toggle(id);

  Future<void> loadInitial() async {
    // Prevent duplicate initial load
    if (state.isInitialLoading) return;

    _page = 0;

    _emitSafe(
      state.copyWith(
        isInitialLoading: true,
        hasMore: true,
        clearErrorMessage: true,
        clearLoadMoreErrorMessage: true,
        items: const [],
      ),
    );

    final res = await _repo.getTopStoriesPage(page: _page, pageSize: _pageSize);
    if (isClosed) return;

    res.when(
      success: (list) {
        final hasMore = list.length == _pageSize;
        _emitSafe(
          state.copyWith(
            items: list,
            isInitialLoading: false,
            hasMore: hasMore,
          ),
        );
      },
      failure: (f) {
        _emitSafe(
          state.copyWith(isInitialLoading: false, errorMessage: f.message),
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;

    _emitSafe(
      state.copyWith(
        isRefreshing: true,
        clearErrorMessage: true,
        clearLoadMoreErrorMessage: true,
      ),
    );

    _repo.reset();
    _page = 0;

    final res = await _repo.getTopStoriesPage(page: _page, pageSize: _pageSize);
    if (isClosed) return;

    res.when(
      success: (list) {
        final hasMore = list.length == _pageSize;
        _emitSafe(
          state.copyWith(items: list, isRefreshing: false, hasMore: hasMore),
        );
      },
      failure: (f) {
        // Keep old items if exist, but show refresh error
        _emitSafe(state.copyWith(isRefreshing: false, errorMessage: f.message));
      },
    );
  }

  Future<void> loadMore() async {
    // hard guards
    if (state.isInitialLoading || state.isRefreshing || state.isLoadingMore) {
      return;
    }
    if (!state.hasMore) return;

    _emitSafe(
      state.copyWith(isLoadingMore: true, clearLoadMoreErrorMessage: true),
    );

    final nextPage = _page + 1;
    final res = await _repo.getTopStoriesPage(
      page: nextPage,
      pageSize: _pageSize,
    );
    if (isClosed) return;

    res.when(
      success: (list) {
        // If empty => no more
        if (list.isEmpty) {
          _emitSafe(state.copyWith(isLoadingMore: false, hasMore: false));
          return;
        }

        _page = nextPage;

        // De-dupe by id (optional safety)
        final existingIds = state.items.map((e) => e.id).toSet();
        final merged = <Story>[
          ...state.items,
          ...list.where((e) => !existingIds.contains(e.id)),
        ];

        final hasMore = list.length == _pageSize;

        _emitSafe(
          state.copyWith(items: merged, isLoadingMore: false, hasMore: hasMore),
        );
      },
      failure: (f) {
        // non-blocking: keep list, show loadMore error
        _emitSafe(
          state.copyWith(isLoadingMore: false, loadMoreErrorMessage: f.message),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _favoritesSub?.cancel();
    return super.close();
  }
}
