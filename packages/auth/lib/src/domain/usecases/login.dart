import 'package:core/core.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<Result<AuthUser>> call({
    required String email,
    required String password,
  }) =>
      _repo.login(email: email, password: password);
}
