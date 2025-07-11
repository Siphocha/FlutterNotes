import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //our authentication with firebase auttthhh! just call it _auth.
  final FirebaseAuth _auth;

  AuthBloc({required FirebaseAuth auth})
    : _auth = auth,
      super(AuthState.initial()) {
    //Event handlers for the key functions of authentication
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    //Check them if they're authenticated
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Skip loading state for initial check to speed up startup
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthState.authenticated(user.email ?? ''));
      } else {
        emit(AuthState.unauthenticated()); // Immediately show auth screen
      }
    } catch (e) {
      emit(AuthState.error('Session check failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpRequested(
    //Signup requested for authentication
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      await _auth
          .createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          )
          .timeout(const Duration(seconds: 15)); // Add timeout

      emit(AuthState.authenticated(event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Signing up failed'));
    } on TimeoutException {
      emit(AuthState.error('Connection timeout. Try again'));
    } catch (e) {
      emit(AuthState.error('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLoginRequested(
    //Authenticate them when logging in
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      await _auth
          .signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          )
          .timeout(const Duration(seconds: 15)); // Add timeout

      emit(AuthState.authenticated(event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Logging in failed'));
    } on TimeoutException {
      emit(AuthState.error('Connection timeout. Try again'));
    } catch (e) {
      emit(AuthState.error('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    //Can only logout if you've been authenticated first
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.loading());
      await _auth.signOut();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Logout failed: ${e.toString()}'));
    }
  }
}
