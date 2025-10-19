import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/entities/user.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignInWithGoogle {
  final AuthRepository _authRepository;

  const SignInWithGoogle(this._authRepository);

  Future<User> call() {
    return _authRepository.signInWithGoogle();
  }
}
