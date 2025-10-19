import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/domain/entities/book_ficha.dart';
import 'package:reading_app/features/books/domain/repositories/book_ficha_repository.dart';

@Injectable(as: BookFichaRepository)
class BookFichaRepositoryImpl implements BookFichaRepository {
  final FirebaseFirestore _firestore;

  BookFichaRepositoryImpl(this._firestore);

  @override
  Future<void> saveBookFicha(BookFicha ficha) async {
    try {
      await _firestore
          .collection('book_fichas')
          .doc(ficha.id)
          .set(ficha.toJson());
    } catch (e) {
      throw Exception('Error al guardar la ficha del libro: $e');
    }
  }

  @override
  Future<BookFicha?> getBookFichaForUserAndBook(
    String userId,
    String bookId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('book_fichas')
              .where('userId', isEqualTo: userId)
              .where('bookId', isEqualTo: bookId)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return BookFicha.fromJson(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener la ficha del libro: $e');
    }
  }

  @override
  Future<List<BookFicha>> getUserBookFichas(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('book_fichas')
              .where('userId', isEqualTo: userId)
              .get();

      return querySnapshot.docs
          .map((doc) => BookFicha.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener las fichas del usuario: $e');
    }
  }

  @override
  Future<void> deleteBookFicha(String fichaId) async {
    try {
      await _firestore.collection('book_fichas').doc(fichaId).delete();
    } catch (e) {
      throw Exception('Error al borrar la ficha del libro: $e');
    }
  }
}
