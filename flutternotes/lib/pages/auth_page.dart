import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authLogic/auth_bloc.dart';
import '../authLogic/auth_state.dart';
import '../widgets/auth_forms.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes App')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Unknown error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: const AuthForm(isLogin: true), // Default to login form
      ),
    );
  }
}
