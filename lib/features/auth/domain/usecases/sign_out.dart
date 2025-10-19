import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class SignOut {
  final AuthRepository _authRepository;

  const SignOut(this._authRepository);

  Future<void> call() {
    return _authRepository.signOut();
  }
}
