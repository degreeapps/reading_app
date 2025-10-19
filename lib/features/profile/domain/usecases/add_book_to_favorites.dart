import 'package:injectable/injectable.dart';
import 'package:reading_app/features/profile/domain/repositories/profile_repository.dart';

@injectable
class AddBookToFavorites {
  final ProfileRepository _repository;

  AddBookToFavorites(this._repository);

  Future<void> call(String uid, String bookId) async {
    await _repository.addBookToFavorites(uid, bookId);
  }
}
