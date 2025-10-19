import 'package:injectable/injectable.dart';
import 'package:reading_app/features/auth/domain/repositories/auth_repository.dart';

@injectable
class DeleteAccount {
  final AuthRepository _repository;

  DeleteAccount(this._repository);

  Future<void> call() async {
    await _repository.deleteAccount();
  }
}
