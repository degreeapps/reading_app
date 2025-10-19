part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signInWithEmail({
    required String email,
    required String password,
  }) = _SignInWithEmail;

  const factory AuthEvent.signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String username,
  }) = _SignUpWithEmail;

  const factory AuthEvent.signInWithGoogle() = _SignInWithGoogle;

  const factory AuthEvent.signOut() = _SignOut;

  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;

  const factory AuthEvent.changePassword({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePassword;
}
