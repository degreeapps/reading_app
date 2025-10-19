import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reading_app/features/books/domain/entities/book.dart';

class GoogleBooksApiDatasource {
  final String apiKey;
  GoogleBooksApiDatasource(this.apiKey);

  Future<List<Book>> searchBooks({
    String? query,
    String? author,
    String? title,
    String? isbn,
    String? category,
    String? language,
  }) async {
    final params = <String, String>{'key': apiKey, 'maxResults': '20'};
    final buffer = StringBuffer();
    if (query != null && query.isNotEmpty) {
      buffer.write(query);
    }
    if (author != null && author.isNotEmpty) {
      buffer.write('+inauthor:$author');
    }
    if (title != null && title.isNotEmpty) buffer.write('+intitle:$title');
    if (isbn != null && isbn.isNotEmpty) buffer.write('+isbn:$isbn');
    if (category != null && category.isNotEmpty) {
      buffer.write('+subject:$category');
    }
    if (language != null && language.isNotEmpty) {
      params['langRestrict'] = language;
    }
    params['q'] = buffer.isEmpty ? ' ' : buffer.toString();

    final uri = Uri.https('www.googleapis.com', '/books/v1/volumes', params);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error al buscar libros: ${response.body}');
    }
    final data = json.decode(response.body);
    final List items = data['items'] ?? [];
    return items.map((item) => _parseBook(item)).toList();
  }

  Book _parseBook(Map<String, dynamic> item) {
    final volume = item['volumeInfo'] ?? {};
    final industryIdentifiers = volume['industryIdentifiers'] as List?;
    String? isbn;
    if (industryIdentifiers != null) {
      final isbn13 = industryIdentifiers.firstWhere(
        (id) => id['type'] == 'ISBN_13',
        orElse: () => null,
      );
      isbn = isbn13 != null ? isbn13['identifier'] : null;
    }
    return Book(
      id: item['id'] ?? '',
      title: volume['title'] ?? '',
      authors: (volume['authors'] as List?)?.cast<String>() ?? [],
      description: volume['description'],
      thumbnail: volume['imageLinks']?['thumbnail'],
      pageCount: volume['pageCount'],
      publishedDate: volume['publishedDate'],
      categories: (volume['categories'] as List?)?.cast<String>(),
      language: volume['language'],
      isbn: isbn,
    );
  }
}
