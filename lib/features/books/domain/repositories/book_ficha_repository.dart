import 'package:reading_app/features/books/domain/entities/book_ficha.dart';

abstract class BookFichaRepository {
  Future<void> saveBookFicha(BookFicha ficha);
  Future<BookFicha?> getBookFichaForUserAndBook(String userId, String bookId);
  Future<List<BookFicha>> getUserBookFichas(String userId);
  Future<void> deleteBookFicha(String fichaId);
}
