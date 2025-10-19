import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/repositories/book_repository.dart';

@injectable
class GetFavoriteBooks {
  final BookRepository _repository;
  const GetFavoriteBooks(this._repository);

  Future<List<Book>> call() {
    return _repository.getFavoriteBooks();
  }
}
