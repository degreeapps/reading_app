import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class RemoveBookFromFavorites {
  final ProfileRepository _repository;

  RemoveBookFromFavorites(this._repository);

  Future<void> call(String uid, String bookId) async {
    await _repository.removeBookFromFavorites(uid, bookId);
  }
}
