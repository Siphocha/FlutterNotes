import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? email;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.email,
  });

  factory AuthState.initial() => const AuthState();
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(String email) =>
      AuthState(status: AuthStatus.authenticated, email: email);
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, errorMessage, email];

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
    );
  }
}
