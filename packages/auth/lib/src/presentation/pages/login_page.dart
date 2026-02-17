import 'package:auth/src/routing/auth_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, c) =>
      p.error != c.error || p.user != c.user,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        // No navigation here. Redirect will handle it when user becomes non-null.
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          state.error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pass,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<AuthCubit>().login(_email.text, _pass.text),
                        child: Text(state.isLoading ? 'Loading...' : 'Login'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed(AuthRouteNames.register),
                      child: const Text('Create account'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
