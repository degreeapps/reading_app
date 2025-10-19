import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/repositories/book_repository.dart';

@injectable
class AddBook {
  final BookRepository _repository;
  const AddBook(this._repository);

  Future<void> call(Book book) {
    return _repository.addBook(book);
  }
}
