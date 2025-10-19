import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? thumbnail;
  final int? pageCount;
  final String? publishedDate;
  final List<String>? categories;
  final String? language;
  final String? isbn;
  final String? userId;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.thumbnail,
    this.pageCount,
    this.publishedDate,
    this.categories,
    this.language,
    this.isbn,
    this.userId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);

  Book copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? description,
    String? thumbnail,
    int? pageCount,
    String? publishedDate,
    List<String>? categories,
    String? language,
    String? isbn,
    String? userId,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      pageCount: pageCount ?? this.pageCount,
      publishedDate: publishedDate ?? this.publishedDate,
      categories: categories ?? this.categories,
      language: language ?? this.language,
      isbn: isbn ?? this.isbn,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book &&
        other.id == id &&
        other.title == title &&
        other.authors == authors &&
        other.description == description &&
        other.thumbnail == thumbnail &&
        other.pageCount == pageCount &&
        other.publishedDate == publishedDate &&
        other.categories == categories &&
        other.language == language &&
        other.isbn == isbn &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      authors,
      description,
      thumbnail,
      pageCount,
      publishedDate,
      categories,
      language,
      isbn,
      userId,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, authors: $authors, description: $description, thumbnail: $thumbnail, pageCount: $pageCount, publishedDate: $publishedDate, categories: $categories, language: $language, isbn: $isbn, userId: $userId)';
  }
}
