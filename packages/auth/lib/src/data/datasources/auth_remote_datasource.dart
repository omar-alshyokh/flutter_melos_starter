import 'package:core/core.dart';
import '../dto/auth_user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<Result<AuthUserDto>> login({required String email, required String password});
  Future<Result<AuthUserDto>> register({required String name, required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<AuthUserDto?>> currentUser();
}
