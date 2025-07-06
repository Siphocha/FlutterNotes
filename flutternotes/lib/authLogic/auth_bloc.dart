import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  AuthBloc({required FirebaseAuth auth})
    : _auth = auth,
      super(AuthState.initial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        emit(AuthState.authenticated(user.email!));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.authenticated(event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Sign up failed'));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthState.authenticated(event.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Login failed'));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());
    try {
      await _auth.signOut();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }
}
