import 'package:core/core.dart';
import '../entities/story.dart';
import '../repositories/posts_repository.dart';

class GetTopStoriesPageUseCase {
  final PostsRepository _repo;

  GetTopStoriesPageUseCase(this._repo);

  Future<Result<List<Story>>> call({
    required int page,
    required int pageSize,
  }) {
    return _repo.getTopStoriesPage(page: page, pageSize: pageSize);
  }
}
