import 'package:core/core.dart';
import 'package:posts/src/domain/entities/story.dart';
import 'package:posts/src/domain/repositories/posts_repository.dart';

class GetStoryDetailsUseCase {
  final PostsRepository _repo;

  GetStoryDetailsUseCase(this._repo);

  Future<Result<Story>> call(int id) => _repo.getStory(id);
}
