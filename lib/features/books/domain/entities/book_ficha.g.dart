// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_ficha.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookFicha _$BookFichaFromJson(Map<String, dynamic> json) => BookFicha(
  id: json['id'] as String,
  bookId: json['bookId'] as String,
  userId: json['userId'] as String,
  rating: (json['rating'] as num).toInt(),
  summary: json['summary'] as String?,
  learnings: json['learnings'] as String?,
  thoughts: json['thoughts'] as String?,
  sharedWithTeachers: json['sharedWithTeachers'] as bool? ?? false,
  sharedWithParents: json['sharedWithParents'] as bool? ?? false,
  createdAt: BookFicha._timestampFromJson(json['createdAt']),
  updatedAt: BookFicha._timestampFromJson(json['updatedAt']),
);

Map<String, dynamic> _$BookFichaToJson(BookFicha instance) => <String, dynamic>{
  'id': instance.id,
  'bookId': instance.bookId,
  'userId': instance.userId,
  'rating': instance.rating,
  'summary': instance.summary,
  'learnings': instance.learnings,
  'thoughts': instance.thoughts,
  'sharedWithTeachers': instance.sharedWithTeachers,
  'sharedWithParents': instance.sharedWithParents,
  'createdAt': BookFicha._timestampToJson(instance.createdAt),
  'updatedAt': BookFicha._timestampToJson(instance.updatedAt),
};
