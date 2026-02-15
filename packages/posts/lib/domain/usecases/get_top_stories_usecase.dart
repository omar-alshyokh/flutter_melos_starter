import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:posts/domain/entities/story.dart';
import 'package:posts/domain/repositories/posts_repository.dart';

@lazySingleton
class GetTopStoriesUseCase {
  final PostsRepository _repo;

  GetTopStoriesUseCase(this._repo);

  Future<Result<List<Story>>> call({int limit = 20}) {
    return _repo.getTopStories(limit: limit);
  }
}
