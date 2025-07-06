import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../authLogic/auth_bloc.dart';
import '../authLogic/auth_event.dart';
import '../authLogic/auth_state.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;

  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <-- Added Scaffold wrapper
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error/s'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Added title
                      Text(
                        widget.isLogin ? 'Login' : 'Sign Up',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 32),
                      // Email field with Material wrapper
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter ur email';
                            }
                            if (!value.contains('@')) {
                              return 'Make sure the email is VALID!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password field with Material wrapper
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your password! 6 CHARS';
                            }
                            if (value.length < 6) {
                              return 'MAKE THE PASSWORD 6 CHARACTERS';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                    widget.isLogin ? 'Login' : 'Signing Up',
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Additional options
                      if (widget.isLogin) ...[
                        TextButton(
                          onPressed: _isLoading ? null : _handlePasswordReset,
                          child: const Text('Forgot ur password?'),
                        ),
                      ],
                      TextButton(
                        onPressed: _isLoading ? null : _toggleAuthMode,
                        child: Text(
                          widget.isLogin
                              ? 'Create ur account'
                              : 'I already have one',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final email = _emailController.text;
      final password = _passwordController.text;

      final authEvent =
          widget.isLogin
              ? LoginRequested(email, password)
              : SignUpRequested(email, password);

      context.read<AuthBloc>().add(authEvent);
    }
  }

  void _handlePasswordReset() {
    final email = _emailController.text;
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email first')),
      );
      return;
    }

    setState(() => _isLoading = true);
  }

  void _toggleAuthMode() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthForm(isLogin: !widget.isLogin),
      ),
    );
  }
}
