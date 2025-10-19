import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ChangePassword {
  final AuthRepository _authRepository;

  ChangePassword(this._authRepository);

  Future<void> call(String currentPassword, String newPassword) async {
    if (currentPassword.isEmpty) {
      throw Exception('Current password is required');
    }
    if (newPassword.isEmpty) {
      throw Exception('New password is required');
    }
    if (newPassword.length < 6) {
      throw Exception('New password must be at least 6 characters');
    }
    if (currentPassword == newPassword) {
      throw Exception('New password must be different from current password');
    }

    return await _authRepository.changePassword(currentPassword, newPassword);
  }
}
