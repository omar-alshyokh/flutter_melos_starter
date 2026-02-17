library posts_di;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:posts/src/data/datasources/posts_remote_datasource.dart';
import 'package:posts/src/data/repositories/posts_repository_impl.dart';
import 'package:posts/src/domain/repositories/posts_repository.dart';
import 'package:posts/src/domain/usecases/get_story_details.dart';
import 'package:posts/src/domain/usecases/get_top_stories.dart';
import 'package:posts/src/presentation/cubit/post_details_cubit.dart';
import 'package:posts/src/presentation/cubit/posts_cubit.dart';

void configurePostsDependencies(GetIt getIt) {
  // data source
  if (!getIt.isRegistered<PostsRemoteDataSource>()) {
    getIt.registerLazySingleton<PostsRemoteDataSource>(
          () => PostsRemoteDataSource(getIt<Dio>()),
    );
  }

  // repository
  if (!getIt.isRegistered<PostsRepository>()) {
    getIt.registerLazySingleton<PostsRepository>(
          () => PostsRepositoryImpl(getIt<PostsRemoteDataSource>()),
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
    getIt.registerFactory(() => PostsCubit(getIt<PostsRepository>(), pageSize: 20));
  }

  if (!getIt.isRegistered<PostDetailsCubit>()) {
    getIt.registerFactory(() => PostDetailsCubit(getIt<GetStoryDetailsUseCase>()));
  }
}
