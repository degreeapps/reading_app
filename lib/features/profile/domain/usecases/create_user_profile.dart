import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class CreateUserProfile {
  final ProfileRepository _repository;

  CreateUserProfile(this._repository);

  Future<void> call(UserProfile profile) async {
    await _repository.createUserProfile(profile);
  }
}
