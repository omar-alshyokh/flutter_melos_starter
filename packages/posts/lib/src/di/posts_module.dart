import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../data/datasources/posts_remote_datasource.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/repositories/posts_repository.dart';
import '../domain/usecases/get_story_details.dart';
import '../domain/usecases/get_top_stories.dart';
import '../presentation/cubit/post_details_cubit.dart';
import '../presentation/cubit/posts_cubit.dart';

@module
abstract class PostsModule {
  @lazySingleton
  PostsRemoteDataSource postsRemote(Dio dio) => PostsRemoteDataSource(dio);

  @lazySingleton
  PostsRepository postsRepo(PostsRemoteDataSource remote) =>
      PostsRepositoryImpl(remote);

  @lazySingleton
  GetTopStoriesPageUseCase getTopStories(PostsRepository repo) =>
      GetTopStoriesPageUseCase(repo);

  @lazySingleton
  GetStoryDetailsUseCase getStoryDetails(PostsRepository repo) =>
      GetStoryDetailsUseCase(repo);

  @lazySingleton
  PostsCubit postsCubit(PostsRepository repo) => PostsCubit(repo, pageSize: 20);

  @factoryMethod
  PostDetailsCubit postDetailsCubit(GetStoryDetailsUseCase useCase) =>
      PostDetailsCubit(useCase);
}
