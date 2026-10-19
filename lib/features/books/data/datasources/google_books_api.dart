import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reading_app/features/books/domain/entities/book.dart';

class GoogleBooksApi {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  static const String _apiKey = String.fromEnvironment('GOOGLE_BOOKS_API_KEY');

  Future<List<Book>> searchBooks(String query) async {
    try {
      final url = Uri.parse('$_baseUrl?q=$query&key=$_apiKey&maxResults=20');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];

        return items.map((item) => _parseBook(item)).toList();
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  Future<Book?> getBookById(String id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id?key=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseBook(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get book: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting book: $e');
    }
  }

  Book _parseBook(Map<String, dynamic> item) {
    final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;
    final industryIdentifiers = volumeInfo['industryIdentifiers'] as List?;

    return Book(
      id: item['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Título desconocido',
      authors:
          (volumeInfo['authors'] as List?)?.cast<String>() ??
          ['Autor desconocido'],
      description: volumeInfo['description'] as String?,
      thumbnail:
          imageLinks?['thumbnail'] as String? ??
          imageLinks?['smallThumbnail'] as String?,
      pageCount: volumeInfo['pageCount'] as int?,
      publishedDate: volumeInfo['publishedDate'] as String?,
      categories: (volumeInfo['categories'] as List?)?.cast<String>(),
      language: volumeInfo['language'] as String?,
      isbn:
          industryIdentifiers?.isNotEmpty == true
              ? industryIdentifiers!.first['identifier'] as String?
              : null,
    );
  }
}
