import 'package:reading_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Get current user
  User? getCurrentUser();

  /// Sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password);

  /// Sign up with email and password
  Future<User> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String username,
  );

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign out
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Delete current user account
  Future<void> deleteAccount();

  /// Change password for current user
  Future<void> changePassword(String currentPassword, String newPassword);

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;
}
