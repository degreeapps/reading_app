import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/friends_repository.dart';

@injectable
class GetFriends {
  final FriendsRepository _repository;

  const GetFriends(this._repository);

  Future<List<String>> call(String userId) {
    return _repository.getFriends(userId);
  }
}
