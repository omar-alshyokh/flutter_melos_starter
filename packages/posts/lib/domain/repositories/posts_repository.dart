import 'package:core/core.dart';
import 'package:posts/domain/entities/story.dart';

abstract class PostsRepository {
  Future<Result<List<Story>>> getTopStories({int limit = 20});
}
