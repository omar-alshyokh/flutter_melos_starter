import 'package:core/core.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<Result<AuthUser>> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repo.register(name: name, email: email, password: password);
}
