import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/posts_repository.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepository _repo;

  // keep paging inside cubit
  final int _pageSize;
  int _page = 0;

  PostsCubit(
      this._repo, {
        int pageSize = 20,
      })  : _pageSize = pageSize,
        super(const PostsState());

  Future<void> loadInitial() async {
    // Prevent duplicate initial load
    if (state.isInitialLoading) return;

    _page = 0;

    emit(state.copyWith(
      isInitialLoading: true,
      hasMore: true,
      clearErrorMessage: true,
      clearLoadMoreErrorMessage: true,
      items: const [],
    ));

    final res = await _repo.getTopStoriesPage(page: _page, pageSize: _pageSize);

    res.when(
      success: (list) {
        final hasMore = list.length == _pageSize;
        emit(state.copyWith(
          items: list,
          isInitialLoading: false,
          hasMore: hasMore,
        ));
      },
      failure: (f) {
        emit(state.copyWith(
          isInitialLoading: false,
          errorMessage: f.message,
        ));
      },
    );
  }

  Future<void> refresh() async {
    if (state.isRefreshing) return;

    emit(state.copyWith(
      isRefreshing: true,
      clearErrorMessage: true,
      clearLoadMoreErrorMessage: true,
    ));

    _repo.reset();
    _page = 0;

    final res = await _repo.getTopStoriesPage(page: _page, pageSize: _pageSize);

    res.when(
      success: (list) {
        final hasMore = list.length == _pageSize;
        emit(state.copyWith(
          items: list,
          isRefreshing: false,
          hasMore: hasMore,
        ));
      },
      failure: (f) {
        // Keep old items if exist, but show refresh error
        emit(state.copyWith(
          isRefreshing: false,
          errorMessage: f.message,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    // hard guards
    if (state.isInitialLoading || state.isRefreshing || state.isLoadingMore) return;
    if (!state.hasMore) return;

    emit(state.copyWith(
      isLoadingMore: true,
      clearLoadMoreErrorMessage: true,
    ));

    final nextPage = _page + 1;
    final res = await _repo.getTopStoriesPage(page: nextPage, pageSize: _pageSize);

    res.when(
      success: (list) {
        // If empty => no more
        if (list.isEmpty) {
          emit(state.copyWith(isLoadingMore: false, hasMore: false));
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

        emit(state.copyWith(
          items: merged,
          isLoadingMore: false,
          hasMore: hasMore,
        ));
      },
      failure: (f) {
        // non-blocking: keep list, show loadMore error
        emit(state.copyWith(
          isLoadingMore: false,
          loadMoreErrorMessage: f.message,
        ));
      },
    );
  }
}
