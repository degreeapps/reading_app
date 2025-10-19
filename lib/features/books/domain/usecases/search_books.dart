import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/repositories/book_repository.dart';

@injectable
class SearchBooks {
  final BookRepository _repository;
  const SearchBooks(this._repository);

  Future<List<Book>> call({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  }) {
    return _repository.searchBooks(
      query: query,
      author: author,
      title: title,
      isbn: isbn,
      category: category,
      language: language,
    );
  }
}
