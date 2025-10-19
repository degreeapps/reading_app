import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/entities/user.dart';
import 'package:reading_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:reading_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:reading_app/features/auth/domain/usecases/sign_out.dart';
import 'package:reading_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:reading_app/features/auth/domain/usecases/change_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final ChangePassword _changePassword;

  AuthBloc(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._signInWithGoogle,
    this._signOut,
    this._changePassword,
  ) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        signInWithEmail: (e) => _onSignInWithEmail(e, emit),
        signUpWithEmail: (e) => _onSignUpWithEmail(e, emit),
        signInWithGoogle: (e) => _onSignInWithGoogle(e, emit),
        signOut: (e) => _onSignOut(e, emit),
        checkAuthStatus: (e) => _onCheckAuthStatus(e, emit),
        changePassword: (e) => _onChangePassword(e, emit),
      );
    });
  }

  Future<void> _onSignInWithEmail(
    _SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _signInWithEmail(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignUpWithEmail(
    _SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _signUpWithEmail(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        username: event.username,
      );
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
    _SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _signInWithGoogle();
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onSignOut(_SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    // This will be handled by the auth state stream
    emit(const AuthState.loading());
  }

  Future<void> _onChangePassword(
    _ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(const AuthState.loading());
    try {
      await _changePassword(event.currentPassword, event.newPassword);
      // Restore authenticated state after successful password change
      if (currentState is _Authenticated) {
        emit(currentState);
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
      // Restore authenticated state after error
      if (currentState is _Authenticated) {
        emit(currentState);
      }
    }
  }
}
