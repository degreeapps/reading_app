import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/entities/friend_request.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class GetFriendRequests {
  final FriendsRepository _repository;

  const GetFriendRequests(this._repository);

  Future<List<FriendRequest>> call(String userId) {
    return _repository.getPendingFriendRequests(userId);
  }
}
