
import 'package:auth/src/domain/entities/auth_user.dart';

class AuthState {
  final bool isLoading;
  final AuthUser? user;
  final String? error;

  const AuthState({
    required this.isLoading,
    required this.user,
    required this.error,
  });

  factory AuthState.initial() => const AuthState(isLoading: false, user: null, error: null);

  AuthState copyWith({
    bool? isLoading,
    AuthUser? user,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
