// auth_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authLogic/auth_bloc.dart';
import '../widgets/auth_forms.dart';
import '../authLogic/auth_state.dart';

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
              SnackBar(content: Text(state.errorMessage ?? 'Unknown error')),
            );
          }
        },
        child: const Padding(padding: EdgeInsets.all(16.0), child: AuthForm()),
      ),
    );
  }
}
