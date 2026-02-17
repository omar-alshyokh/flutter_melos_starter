import 'dart:async';
import 'package:core/core.dart';

import 'auth_remote_datasource.dart';
import '../dto/auth_user_dto.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  // simple in-memory "db"
  final Map<String, _MockUserRecord> _usersByEmail = {
    'test@test.com': _MockUserRecord(
      id: '1',
      name: 'Test User',
      email: 'test@test.com',
      password: '123456',
    ),
  };

  AuthUserDto? _session; // acts like "currently logged in user"

  /// Simulate network delay (keep it small)
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 350));

  @override
  Future<Result<AuthUserDto>> login({
    required String email,
    required String password,
  }) async {
    return NetworkCall.guard(() async {
      await _delay();

      final record = _usersByEmail[email.trim().toLowerCase()];
      if (record == null) {
        throw Failure(
          type: FailureType.unauthorized,
          message: 'Invalid email or password',
        );
      }

      if (record.password != password) {
        throw Failure(
          type: FailureType.unauthorized,
          message: 'Invalid email or password',
        );
      }

      final dto = AuthUserDto(
        id: record.id,
        name: record.name,
        email: record.email,
      );

      _session = dto;
      return dto;
    });
  }

  @override
  Future<Result<AuthUserDto>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return NetworkCall.guard(() async {
      await _delay();

      final normalizedEmail = email.trim().toLowerCase();
      if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
        throw Failure(
          type: FailureType.validation,
          message: 'Please enter a valid email',
        );
      }

      if (password.length < 6) {
        throw Failure(
          type: FailureType.validation,
          message: 'Password must be at least 6 characters',
        );
      }

      if (_usersByEmail.containsKey(normalizedEmail)) {
        throw Failure(
          type: FailureType.conflict,
          message: 'This email is already registered',
        );
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();

      _usersByEmail[normalizedEmail] = _MockUserRecord(
        id: id,
        name: name.trim().isEmpty ? 'User' : name.trim(),
        email: normalizedEmail,
        password: password,
      );

      final dto = AuthUserDto(
        id: id,
        name: _usersByEmail[normalizedEmail]!.name,
        email: normalizedEmail,
      );

      _session = dto;
      return dto;
    });
  }

  @override
  Future<Result<void>> logout() async {
    return NetworkCall.guard(() async {
      await _delay();
      _session = null;
      return;
    });
  }

  @override
  Future<Result<AuthUserDto?>> currentUser() async {
    return NetworkCall.guard(() async {
      await _delay();
      return _session; // null if not logged in
    });
  }
}

class _MockUserRecord {
  final String id;
  final String name;
  final String email;
  final String password;

  _MockUserRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
