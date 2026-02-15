import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:posts/data/datasources/posts_remote_datasource.dart';
import 'package:posts/data/models/story_model.dart';
import 'package:posts/domain/entities/story.dart';
import 'package:posts/domain/repositories/posts_repository.dart';

@LazySingleton(as: PostsRepository)
class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource _remote;

  PostsRepositoryImpl(this._remote);

  @override
  Future<Result<List<Story>>> getTopStories({int limit = 20}) async {
    try {
      final ids = await _remote.fetchTopStoryIds();
      final top = ids.take(limit).toList();

      final futures = top.map((id) async {
        final json = await _remote.fetchItem(id);
        return StoryModel.fromJson(json).toEntity();
      }).toList();

      final stories = await Future.wait(futures);
      return Success(stories);
    } catch (e) {
      return Failure(AppFailure('Failed to load top stories', cause: e));
    }
  }
}
