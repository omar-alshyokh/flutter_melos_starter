import 'package:dio/dio.dart';
import 'package:core/core.dart';
import 'package:core/core_di.dart';
import 'package:get_it/get_it.dart';
import 'package:posts/src/data/datasources/favorites_local_datasource.dart';
import 'package:posts/src/data/datasources/posts_remote_datasource.dart';
import 'package:posts/src/data/repositories/favorites_repository_impl.dart';
import 'package:posts/src/data/repositories/posts_repository_impl.dart';
import 'package:posts/src/domain/repositories/favorites_repository.dart';
import 'package:posts/src/domain/repositories/posts_repository.dart';
import 'package:posts/src/domain/usecases/get_story_details.dart';
import 'package:posts/src/domain/usecases/get_top_stories.dart';
import 'package:posts/src/presentation/cubit/favorites_cubit.dart';
import 'package:posts/src/presentation/cubit/post_details_cubit.dart';
import 'package:posts/src/presentation/cubit/posts_cubit.dart';
import 'package:posts/src/presentation/cubit/top_posts_cubit.dart';

Future<void> configurePostsDependencies(GetIt getIt) async {
  if (!getIt.isRegistered<AppPrefs>()) {
    final prefs = await CoreModule.sharedPrefs();
    getIt.registerLazySingleton<AppPrefs>(() => CoreModule.appPrefs(prefs));
  }

  // data source
  if (!getIt.isRegistered<PostsRemoteDataSource>()) {
    getIt.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSource(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<FavoritesLocalDataSource>()) {
    getIt.registerLazySingleton<FavoritesLocalDataSource>(
      () => FavoritesLocalDataSource(getIt<AppPrefs>()),
    );
  }

  // repository
  if (!getIt.isRegistered<PostsRepository>()) {
    getIt.registerLazySingleton<PostsRepository>(
      () => PostsRepositoryImpl(getIt<PostsRemoteDataSource>()),
    );
  }

  if (!getIt.isRegistered<FavoritesRepository>()) {
    getIt.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(getIt<FavoritesLocalDataSource>()),
    );
  }

  // use cases
  if (!getIt.isRegistered<GetTopStoriesPageUseCase>()) {
    getIt.registerLazySingleton(
      () => GetTopStoriesPageUseCase(getIt<PostsRepository>()),
    );
  }

  if (!getIt.isRegistered<GetStoryDetailsUseCase>()) {
    getIt.registerLazySingleton(
      () => GetStoryDetailsUseCase(getIt<PostsRepository>()),
    );
  }

  // cubits
  if (!getIt.isRegistered<PostsCubit>()) {
    getIt.registerFactory(
      () => PostsCubit(
        getIt<PostsRepository>(),
        getIt<FavoritesRepository>(),
        pageSize: 20,
      ),
    );
  }

  if (!getIt.isRegistered<TopPostsCubit>()) {
    getIt.registerFactory(
      () =>
          TopPostsCubit(getIt<PostsRepository>(), getIt<FavoritesRepository>()),
    );
  }

  if (!getIt.isRegistered<FavoritesCubit>()) {
    getIt.registerFactory(
      () => FavoritesCubit(
        getIt<PostsRepository>(),
        getIt<FavoritesRepository>(),
      ),
    );
  }

  if (!getIt.isRegistered<PostDetailsCubit>()) {
    getIt.registerFactory(
      () => PostDetailsCubit(getIt<GetStoryDetailsUseCase>()),
    );
  }
}
