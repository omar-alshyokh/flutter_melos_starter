import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool isLoggedIn;

  const AuthState({required this.isLoggedIn});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(isLoggedIn: false));

  void login() {
    emit(const AuthState(isLoggedIn: true));
  }

  void logout() {
    emit(const AuthState(isLoggedIn: false));
  }
}
