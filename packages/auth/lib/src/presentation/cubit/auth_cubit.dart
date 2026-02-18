import 'package:auth/src/domain/repositories/auth_repository.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/domain/usecases/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final AuthRepository _repo;
  void _emitSafe(AuthState next) {
    if (!isClosed) emit(next);
  }

  AuthCubit(this._login, this._register, this._repo)
    : super(AuthState.initial());

  Future<void> loadSession() async {
    _emitSafe(state.copyWith(isLoading: true, clearError: true));
    final res = await _repo.currentUser();
    if (isClosed) return;
    res.when(
      success: (u) => _emitSafe(state.copyWith(isLoading: false, user: u)),
      failure: (f) =>
          _emitSafe(state.copyWith(isLoading: false, error: f.message)),
    );
  }

  Future<void> login(String email, String password) async {
    _emitSafe(state.copyWith(isLoading: true, clearError: true));
    final res = await _login(email: email, password: password);
    if (isClosed) return;
    res.when(
      success: (u) => _emitSafe(state.copyWith(isLoading: false, user: u)),
      failure: (f) =>
          _emitSafe(state.copyWith(isLoading: false, error: f.message)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    _emitSafe(state.copyWith(isLoading: true, clearError: true));
    final res = await _register(name: name, email: email, password: password);
    if (isClosed) return;
    res.when(
      success: (u) => _emitSafe(state.copyWith(isLoading: false, user: u)),
      failure: (f) =>
          _emitSafe(state.copyWith(isLoading: false, error: f.message)),
    );
  }

  Future<void> logout() async {
    _emitSafe(state.copyWith(isLoading: true, clearError: true));
    final res = await _repo.logout();
    if (isClosed) return;
    res.when(
      success: (_) => _emitSafe(state.copyWith(isLoading: false, user: null)),
      failure: (f) =>
          _emitSafe(state.copyWith(isLoading: false, error: f.message)),
    );
  }
}
