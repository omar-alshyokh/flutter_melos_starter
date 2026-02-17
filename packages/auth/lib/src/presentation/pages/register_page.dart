import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Register')),
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
                  TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
                  const SizedBox(height: 12),
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
                          : () async {
                        await context.read<AuthCubit>().register(
                          _name.text,
                          _email.text,
                          _pass.text,
                        );
                        if (mounted && context.read<AuthCubit>().state.user != null) {
                          context.pop(); // go back to login or shell
                        }
                      },
                      child: Text(state.isLoading ? 'Loading...' : 'Create'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
