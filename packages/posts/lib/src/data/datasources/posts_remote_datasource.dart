import 'package:core/core.dart';
import '../dto/story_dto.dart';

class PostsRemoteDataSource extends BaseRemoteDataSource {
  PostsRemoteDataSource(super.dio);

  Future<Result<List<int>>> fetchTopStoryIds() {
    return NetworkCall.guard(() async {
      final res = await dio.get('/topstories.json');
      final data = res.data;

      if (data is! List) {
        throw Failure(
          type: FailureType.parsing,
          message: 'Invalid response (expected list of ids)',
          cause: data,
        );
      }

      return data.whereType<num>().map((e) => e.toInt()).toList(growable: false);
    });
  }

  Future<Result<StoryDto>> fetchStory(int id) {
    return getObject(
      path: '/item/$id.json',
      fromJson: StoryDto.fromJson,
    );
  }
}
