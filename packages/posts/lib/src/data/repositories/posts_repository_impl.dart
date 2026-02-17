import 'dart:async';
import 'package:core/core.dart';
import 'package:posts/src/data/datasources/posts_remote_datasource.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/posts_repository.dart';
import '../dto/story_dto.dart';

class PostsRepositoryImpl extends BaseRepository implements PostsRepository {
  final PostsRemoteDataSource _remote;

  PostsRepositoryImpl(this._remote);

  List<int>? _topIdsCache;                // topstories ids
  final Map<int, Story> _storyCache = {}; // story by id

  @override
  void reset() {
    _topIdsCache = null;
    _storyCache.clear();
  }

  @override
  Future<Result<List<int>>> getTopStoryIds() async {
    if (_topIdsCache != null) return Success(_topIdsCache!);

    final res = await _remote.fetchTopStoryIds();
    res.when(
      success: (ids) => _topIdsCache = ids,
      failure: (_) {},
    );
    return res;
  }

  @override
  Future<Result<Story>> getStory(int id) async {
    final cached = _storyCache[id];
    if (cached != null) return Success(cached);

    final dtoRes = await _remote.fetchStory(id);
    final mapped = mapObject<StoryDto, Story>(dtoRes, (dto) => dto.toEntity());

    mapped.when(
      success: (story) => _storyCache[id] = story,
      failure: (_) {},
    );

    return mapped;
  }

  @override
  Future<Result<List<Story>>> getTopStoriesPage({
    required int page,
    required int pageSize,
  }) async {
    final idsRes = await getTopStoryIds();

    return idsRes.when(
      success: (ids) async {
        if (ids.isEmpty) return const Success(<Story>[]);

        final start = page * pageSize;
        if (start >= ids.length) return const Success(<Story>[]);

        final end = (start + pageSize) > ids.length ? ids.length : (start + pageSize);
        final pageIds = ids.sublist(start, end);

        // fetch missing (no need to assign)
        await _fetchStoriesWithLimit(pageIds, limit: 6);

        final ordered = pageIds
            .map((id) => _storyCache[id])
            .whereType<Story>()
            .toList(growable: false);

        return Success(ordered);
      },
      failure: (f) async => FailureResult<List<Story>>(f),
    );
  }

  Future<void> _fetchStoriesWithLimit(List<int> ids, {int limit = 6}) async {
    final missing = ids.where((id) => !_storyCache.containsKey(id)).toList();

    for (var i = 0; i < missing.length; i += limit) {
      final batch = missing.skip(i).take(limit);
      await Future.wait(batch.map((id) async {
        final res = await getStory(id);
        res.when(success: (_) {}, failure: (_) {});
      }));
    }
  }
}
