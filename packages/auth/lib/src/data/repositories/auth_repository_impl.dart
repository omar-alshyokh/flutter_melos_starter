import 'package:auth/src/data/datasources/auth_remote_datasource.dart';
import 'package:core/core.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepositoryImpl(this._remote);

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    final dtoRes = await _remote.login(email: email, password: password);
    return mapObject(dtoRes, (dto) => dto.toEntity());
  }

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final dtoRes = await _remote.register(name: name, email: email, password: password);
    return mapObject(dtoRes, (dto) => dto.toEntity());
  }

  @override
  Future<Result<void>> logout() => _remote.logout();

  @override
  Future<Result<AuthUser?>> currentUser() async {
    final dtoRes = await _remote.currentUser();
    return dtoRes.when(
      success: (dto) => Success(dto?.toEntity()),
      failure: (f) => FailureResult<AuthUser?>(f),
    );
  }
}
