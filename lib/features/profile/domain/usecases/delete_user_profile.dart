import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class DeleteUserProfile {
  final ProfileRepository _repository;

  DeleteUserProfile(this._repository);

  Future<void> call(String uid) async {
    await _repository.deleteUserProfile(uid);
  }
}
