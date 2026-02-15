import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/auth_cubit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Auth')),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.isLoggedIn
                      ? 'Logged In ✅'
                      : 'Not Logged In ❌'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (state.isLoggedIn) {
                        context.read<AuthCubit>().logout();
                      } else {
                        context.read<AuthCubit>().login();
                      }
                    },
                    child: Text(
                      state.isLoggedIn ? 'Logout' : 'Login',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
