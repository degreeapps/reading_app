import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/entities/user.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignInWithEmail {
  final AuthRepository _authRepository;

  const SignInWithEmail(this._authRepository);

  Future<User> call(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }
}
