import 'package:auth/src/domain/repositories/auth_repository.dart';
import 'package:auth/src/domain/usecases/login.dart';
import 'package:auth/src/domain/usecases/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final AuthRepository _repo;

  AuthCubit(this._login, this._register, this._repo) : super(AuthState.initial());

  Future<void> loadSession() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final res = await _repo.currentUser();
    res.when(
      success: (u) => emit(state.copyWith(isLoading: false, user: u)),
      failure: (f) => emit(state.copyWith(isLoading: false, error: f.message)),
    );
  }

  Future<void> login(String email, String password) async {
    print('[AuthCubit] login() start email=$email');

    emit(state.copyWith(isLoading: true, clearError: true));
    final res = await _login(email: email, password: password);
    res.when(
      success: (u) {
        print('[AuthCubit] login() SUCCESS user=${u.email}');
        emit(state.copyWith(isLoading: false, user: u));
      },
      failure: (f) {
        print('[AuthCubit] login() FAIL ${f.message}');
        emit(state.copyWith(isLoading: false, error: f.message));
      },
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final res = await _register(name: name, email: email, password: password);
    res.when(
      success: (u) => emit(state.copyWith(isLoading: false, user: u)),
      failure: (f) => emit(state.copyWith(isLoading: false, error: f.message)),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final res = await _repo.logout();
    res.when(
      success: (_) => emit(state.copyWith(isLoading: false, user: null)),
      failure: (f) => emit(state.copyWith(isLoading: false, error: f.message)),
    );
  }
}
