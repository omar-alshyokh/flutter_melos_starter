import 'package:core/core.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
  Future<Result<AuthUser?>> currentUser();
}
