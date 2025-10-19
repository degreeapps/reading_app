import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/repositories/book_repository.dart';

@injectable
class RemoveBookFromFavorites {
  final BookRepository _repository;
  const RemoveBookFromFavorites(this._repository);

  Future<void> call(String id) {
    return _repository.removeBookFromFavorites(id);
  }
}
