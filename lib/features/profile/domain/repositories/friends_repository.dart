import 'package:reading_app/features/profile/domain/entities/friend_request.dart';

abstract class FriendsRepository {
  /// Send a friend request
  Future<void> sendFriendRequest(
    String fromUserId,
    String toUserId,
    String fromUserDisplayName,
    String toUserDisplayName,
  );

  /// Accept a friend request
  Future<void> acceptFriendRequest(
    String requestId,
    String fromUserId,
    String toUserId,
  );

  /// Reject a friend request
  Future<void> rejectFriendRequest(String requestId);

  /// Get pending friend requests received by a user
  Future<List<FriendRequest>> getPendingFriendRequests(String userId);

  /// Get sent friend requests by a user
  Future<List<FriendRequest>> getSentFriendRequests(String userId);

  /// Get friends list for a user
  Future<List<String>> getFriends(String userId);

  /// Remove a friend
  Future<void> removeFriend(String userId, String friendId);

  /// Check if friend request already exists
  Future<FriendRequest?> getFriendRequestBetweenUsers(
    String userId1,
    String userId2,
  );

  /// Check if users are already friends
  Future<bool> areFriends(String userId1, String userId2);
}
