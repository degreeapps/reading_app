import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/entities/user.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignUpWithEmail {
  final AuthRepository _authRepository;

  const SignUpWithEmail(this._authRepository);

  Future<User> call({
    required String email,
    required String password,
    required String firstName,
    required String username,
  }) {
    return _authRepository.signUpWithEmailAndPassword(
      email,
      password,
      firstName,
      username,
    );
  }
}
