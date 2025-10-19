import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class RemoveFriend {
  final FriendsRepository _repository;

  const RemoveFriend(this._repository);

  Future<void> call(String userId, String friendId) {
    return _repository.removeFriend(userId, friendId);
  }
}
