// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:posts/data/datasources/hn_posts_remote_datasource.dart' as _i50;
import 'package:posts/data/datasources/posts_remote_datasource.dart' as _i601;
import 'package:posts/data/repositories/posts_repository_impl.dart' as _i184;
import 'package:posts/domain/repositories/posts_repository.dart' as _i435;
import 'package:posts/domain/usecases/get_top_stories_usecase.dart' as _i658;
import 'package:posts/presentation/state/posts_cubit.dart' as _i882;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initPosts({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i601.PostsRemoteDataSource>(
      () => _i50.HnPostsRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i435.PostsRepository>(
      () => _i184.PostsRepositoryImpl(gh<_i601.PostsRemoteDataSource>()),
    );
    gh.lazySingleton<_i658.GetTopStoriesUseCase>(
      () => _i658.GetTopStoriesUseCase(gh<_i435.PostsRepository>()),
    );
    gh.factory<_i882.PostsCubit>(
      () => _i882.PostsCubit(gh<_i658.GetTopStoriesUseCase>()),
    );
    return this;
  }
}
