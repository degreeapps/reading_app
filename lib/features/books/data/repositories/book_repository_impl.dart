import 'package:injectable/injectable.dart';
import 'package:reading_app/features/books/data/datasources/google_books_api.dart';
import 'package:reading_app/features/books/domain/entities/book.dart';
import 'package:reading_app/features/books/domain/repositories/book_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@Injectable(as: BookRepository)
class BookRepositoryImpl implements BookRepository {
  final GoogleBooksApi _api;
  final FirebaseFirestore _firestore;

  BookRepositoryImpl(this._api, this._firestore);

  @override
  Future<List<Book>> searchBooks({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  }) async {
    // Construir query de búsqueda
    final searchQuery = _buildSearchQuery(
      query: query,
      author: author,
      title: title,
      isbn: isbn,
      category: category,
      language: language,
    );

    // Llamar directamente a la API (sin cache problemático)
    try {
      final books = await _api.searchBooks(searchQuery);
      return books;
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  @override
  Future<Book?> getBookById(String id) async {
    return await _api.getBookById(id);
  }

  String _buildSearchQuery({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  }) {
    final parts = <String>[];

    if (query != null && query.isNotEmpty) {
      parts.add(query);
    }
    if (author != null && author.isNotEmpty) {
      parts.add('inauthor:"$author"');
    }
    if (title != null && title.isNotEmpty) {
      parts.add('intitle:"$title"');
    }
    if (isbn != null && isbn.isNotEmpty) {
      parts.add('isbn:$isbn');
    }
    if (category != null && category.isNotEmpty) {
      parts.add('subject:"$category"');
    }
    if (language != null && language.isNotEmpty) {
      parts.add('lang:$language');
    }

    return parts.isEmpty ? 'fiction' : parts.join(' ');
  }

  @override
  Future<void> addBook(Book book) async {
    try {
      await _firestore.collection('books').doc(book.id).set(book.toJson());
    } catch (e) {
      throw Exception('Error saving book: $e');
    }
  }

  @override
  Future<List<Book>> getFavoriteBooks() async {
    // TODO: Implementar favoritos (Firestore/local)
    return [];
  }

  @override
  Future<void> addBookToFavorites(Book book) async {
    // TODO: Implementar favoritos (Firestore/local)
    throw UnimplementedError();
  }

  @override
  Future<void> removeBookFromFavorites(String id) async {
    // TODO: Implementar favoritos (Firestore/local)
    throw UnimplementedError();
  }
}
