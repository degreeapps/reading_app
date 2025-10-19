// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: json['id'] as String,
  title: json['title'] as String,
  authors: (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
  description: json['description'] as String?,
  thumbnail: json['thumbnail'] as String?,
  pageCount: (json['pageCount'] as num?)?.toInt(),
  publishedDate: json['publishedDate'] as String?,
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList(),
  language: json['language'] as String?,
  isbn: json['isbn'] as String?,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'authors': instance.authors,
  'description': instance.description,
  'thumbnail': instance.thumbnail,
  'pageCount': instance.pageCount,
  'publishedDate': instance.publishedDate,
  'categories': instance.categories,
  'language': instance.language,
  'isbn': instance.isbn,
  'userId': instance.userId,
};
