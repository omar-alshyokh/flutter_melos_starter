abstract class PostsRemoteDataSource {
  Future<List<int>> fetchTopStoryIds();
  Future<Map<String, dynamic>> fetchItem(int id);
}
