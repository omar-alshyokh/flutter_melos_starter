import 'package:core/core.dart';
import '../entities/story.dart';

abstract class PostsRepository {
  Future<Result<List<int>>> getTopStoryIds();
  Future<Result<Story>> getStory(int id);

  /// paging (load more)
  Future<Result<List<Story>>> getTopStoriesPage({
    required int page,
    required int pageSize,
  });

  /// clear cache (for pull-to-refresh)
  void reset();
}
