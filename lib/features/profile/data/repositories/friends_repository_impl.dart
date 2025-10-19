import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/friend_request.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@Injectable(as: FriendsRepository)
class FriendsRepositoryImpl implements FriendsRepository {
  final FirebaseFirestore _firestore;

  FriendsRepositoryImpl(this._firestore);

  @override
  Future<void> sendFriendRequest(
    String fromUserId,
    String toUserId,
    String fromUserDisplayName,
    String toUserDisplayName,
  ) async {
    try {
      // Check if request already exists
      final existing = await getFriendRequestBetweenUsers(fromUserId, toUserId);
      if (existing != null) {
        throw Exception('Friend request already exists');
      }

      // Check if already friends
      final alreadyFriends = await areFriends(fromUserId, toUserId);
      if (alreadyFriends) {
        throw Exception('Already friends');
      }

      final docRef = _firestore.collection('friend_requests').doc();
      final request = FriendRequest(
        id: docRef.id,
        fromUserId: fromUserId,
        toUserId: toUserId,
        fromUserDisplayName: fromUserDisplayName,
        toUserDisplayName: toUserDisplayName,
        status: FriendRequestStatus.pending,
        createdAt: DateTime.now(),
      );

      await docRef.set(request.toJson());
    } catch (e) {
      throw Exception('Error sending friend request: $e');
    }
  }

  @override
  Future<void> acceptFriendRequest(
    String requestId,
    String fromUserId,
    String toUserId,
  ) async {
    try {
      final batch = _firestore.batch();

      // Update friend request status
      final requestRef = _firestore
          .collection('friend_requests')
          .doc(requestId);
      batch.update(requestRef, {
        'status': FriendRequestStatus.accepted.name,
        'respondedAt': FieldValue.serverTimestamp(),
      });

      // Add each user to the other's friends list
      final fromUserRef = _firestore
          .collection('user_profiles')
          .doc(fromUserId);
      batch.update(fromUserRef, {
        'friendIds': FieldValue.arrayUnion([toUserId]),
      });

      final toUserRef = _firestore.collection('user_profiles').doc(toUserId);
      batch.update(toUserRef, {
        'friendIds': FieldValue.arrayUnion([fromUserId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Error accepting friend request: $e');
    }
  }

  @override
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await _firestore.collection('friend_requests').doc(requestId).update({
        'status': FriendRequestStatus.rejected.name,
        'respondedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error rejecting friend request: $e');
    }
  }

  @override
  Future<List<FriendRequest>> getPendingFriendRequests(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('friend_requests')
              .where('toUserId', isEqualTo: userId)
              .where('status', isEqualTo: FriendRequestStatus.pending.name)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => FriendRequest.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting pending friend requests: $e');
    }
  }

  @override
  Future<List<FriendRequest>> getSentFriendRequests(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('friend_requests')
              .where('fromUserId', isEqualTo: userId)
              .where('status', isEqualTo: FriendRequestStatus.pending.name)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => FriendRequest.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting sent friend requests: $e');
    }
  }

  @override
  Future<List<String>> getFriends(String userId) async {
    try {
      final doc =
          await _firestore.collection('user_profiles').doc(userId).get();
      if (!doc.exists) return [];

      final data = doc.data();
      final friendIds = data?['friendIds'] as List<dynamic>?;
      return friendIds?.cast<String>() ?? [];
    } catch (e) {
      throw Exception('Error getting friends: $e');
    }
  }

  @override
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      final userRef = _firestore.collection('user_profiles').doc(userId);
      batch.update(userRef, {
        'friendIds': FieldValue.arrayRemove([friendId]),
      });

      final friendRef = _firestore.collection('user_profiles').doc(friendId);
      batch.update(friendRef, {
        'friendIds': FieldValue.arrayRemove([userId]),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Error removing friend: $e');
    }
  }

  @override
  Future<FriendRequest?> getFriendRequestBetweenUsers(
    String userId1,
    String userId2,
  ) async {
    try {
      // Check both directions
      final snapshot1 =
          await _firestore
              .collection('friend_requests')
              .where('fromUserId', isEqualTo: userId1)
              .where('toUserId', isEqualTo: userId2)
              .where('status', isEqualTo: FriendRequestStatus.pending.name)
              .limit(1)
              .get();

      if (snapshot1.docs.isNotEmpty) {
        return FriendRequest.fromJson(snapshot1.docs.first.data());
      }

      final snapshot2 =
          await _firestore
              .collection('friend_requests')
              .where('fromUserId', isEqualTo: userId2)
              .where('toUserId', isEqualTo: userId1)
              .where('status', isEqualTo: FriendRequestStatus.pending.name)
              .limit(1)
              .get();

      if (snapshot2.docs.isNotEmpty) {
        return FriendRequest.fromJson(snapshot2.docs.first.data());
      }

      return null;
    } catch (e) {
      throw Exception('Error checking friend request: $e');
    }
  }

  @override
  Future<bool> areFriends(String userId1, String userId2) async {
    try {
      final friends = await getFriends(userId1);
      return friends.contains(userId2);
    } catch (e) {
      return false;
    }
  }
}
