import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class RejectFriendRequest {
  final FriendsRepository _repository;

  const RejectFriendRequest(this._repository);

  Future<void> call(String requestId) {
    return _repository.rejectFriendRequest(requestId);
  }
}
