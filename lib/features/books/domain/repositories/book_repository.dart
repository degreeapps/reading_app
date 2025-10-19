import 'package:reading_app/features/books/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  });

  Future<Book?> getBookById(String id);

  Future<void> addBook(Book book);

  Future<List<Book>> getFavoriteBooks();

  Future<void> addBookToFavorites(Book book);

  Future<void> removeBookFromFavorites(String id);
}
