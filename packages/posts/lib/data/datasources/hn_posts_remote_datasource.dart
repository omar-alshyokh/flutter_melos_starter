import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:posts/data/datasources/hn_endpoints.dart';
import 'package:posts/data/datasources/posts_remote_datasource.dart';

@LazySingleton(as: PostsRemoteDataSource)
class HnPostsRemoteDataSource implements PostsRemoteDataSource {
  final Dio _dio;

  HnPostsRemoteDataSource(this._dio);

  @override
  Future<List<int>> fetchTopStoryIds() async {
    final res = await _dio.get(HnEndpoints.topStories);
    final data = res.data as List<dynamic>;
    return data.map((e) => e as int).toList();
  }

  @override
  Future<Map<String, dynamic>> fetchItem(int id) async {
    final res = await _dio.get(HnEndpoints.item(id));
    return Map<String, dynamic>.from(res.data as Map);
  }
}
