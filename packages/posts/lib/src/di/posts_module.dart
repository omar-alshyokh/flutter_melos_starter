import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import 'package:posts/src/data/datasources/favorites_local_datasource.dart';
import 'package:posts/src/data/repositories/favorites_repository_impl.dart';
import 'package:posts/src/domain/repositories/favorites_repository.dart';
import '../data/datasources/posts_remote_datasource.dart';
import '../data/repositories/posts_repository_impl.dart';
import '../domain/repositories/posts_repository.dart';
import '../domain/usecases/get_story_details.dart';
import '../domain/usecases/get_top_stories.dart';
import '../presentation/cubit/favorites_cubit.dart';
import '../presentation/cubit/post_details_cubit.dart';
import '../presentation/cubit/posts_cubit.dart';
import '../presentation/cubit/top_posts_cubit.dart';

@module
abstract class PostsModule {
  @lazySingleton
  PostsRemoteDataSource postsRemote(Dio dio) => PostsRemoteDataSource(dio);

  @lazySingleton
  PostsRepository postsRepo(PostsRemoteDataSource remote) =>
      PostsRepositoryImpl(remote);

  @lazySingleton
  FavoritesLocalDataSource favoritesLocal(AppPrefs prefs) =>
      FavoritesLocalDataSource(prefs);

  @lazySingleton
  FavoritesRepository favoritesRepo(FavoritesLocalDataSource local) =>
      FavoritesRepositoryImpl(local);

  @lazySingleton
  GetTopStoriesPageUseCase getTopStories(PostsRepository repo) =>
      GetTopStoriesPageUseCase(repo);

  @lazySingleton
  GetStoryDetailsUseCase getStoryDetails(PostsRepository repo) =>
      GetStoryDetailsUseCase(repo);

  @lazySingleton
  PostsCubit postsCubit(PostsRepository repo, FavoritesRepository favorites) =>
      PostsCubit(repo, favorites, pageSize: 20);

  @lazySingleton
  TopPostsCubit topPostsCubit(
    PostsRepository repo,
    FavoritesRepository favorites,
  ) => TopPostsCubit(repo, favorites);

  @lazySingleton
  FavoritesCubit favoritesCubit(
    PostsRepository postsRepository,
    FavoritesRepository favoritesRepository,
  ) => FavoritesCubit(postsRepository, favoritesRepository);

  @factoryMethod
  PostDetailsCubit postDetailsCubit(GetStoryDetailsUseCase useCase) =>
      PostDetailsCubit(useCase);
}
