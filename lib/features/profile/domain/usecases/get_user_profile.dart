import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/user_profile.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class GetUserProfile {
  final ProfileRepository _repository;

  GetUserProfile(this._repository);

  Future<UserProfile?> call(String uid) async {
    return await _repository.getUserProfile(uid);
  }
}
