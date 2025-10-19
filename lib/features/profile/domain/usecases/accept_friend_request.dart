import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class AcceptFriendRequest {
  final FriendsRepository _repository;

  const AcceptFriendRequest(this._repository);

  Future<void> call(String requestId, String fromUserId, String toUserId) {
    return _repository.acceptFriendRequest(requestId, fromUserId, toUserId);
  }
}
