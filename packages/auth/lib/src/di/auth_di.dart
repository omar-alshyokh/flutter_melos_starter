import 'package:get_it/get_it.dart';

import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/mock_auth_remote_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/register.dart';
import '../presentation/cubit/auth_cubit.dart';

void configureAuthDependencies(GetIt getIt) {
  // Remote
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => MockAuthRemoteDataSource(),
  );

  // Repo
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(getIt<AuthRepository>()),
  );

  // Cubit
  getIt.registerLazySingleton<AuthCubit>(
        () => AuthCubit(
      getIt<LoginUseCase>(),
      getIt<RegisterUseCase>(),
      getIt<AuthRepository>(),
    ),
  );
}
