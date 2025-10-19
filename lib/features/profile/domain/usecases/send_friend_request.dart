import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class SendFriendRequest {
  final FriendsRepository _repository;

  const SendFriendRequest(this._repository);

  Future<void> call({
    required String fromUserId,
    required String toUserId,
    required String fromUserDisplayName,
    required String toUserDisplayName,
  }) {
    return _repository.sendFriendRequest(
      fromUserId,
      toUserId,
      fromUserDisplayName,
      toUserDisplayName,
    );
  }
}
