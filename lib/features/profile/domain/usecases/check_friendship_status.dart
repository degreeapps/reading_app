import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

enum FriendshipStatus { none, friends, requestSent, requestReceived }

@injectable
class CheckFriendshipStatus {
  final FriendsRepository _repository;

  const CheckFriendshipStatus(this._repository);

  Future<FriendshipStatus> call(
    String currentUserId,
    String otherUserId,
  ) async {
    // Check if already friends
    final areFriends = await _repository.areFriends(currentUserId, otherUserId);
    if (areFriends) {
      return FriendshipStatus.friends;
    }

    // Check if there's a pending request
    final request = await _repository.getFriendRequestBetweenUsers(
      currentUserId,
      otherUserId,
    );

    if (request != null) {
      if (request.fromUserId == currentUserId) {
        return FriendshipStatus.requestSent;
      } else {
        return FriendshipStatus.requestReceived;
      }
    }

    return FriendshipStatus.none;
  }
}
