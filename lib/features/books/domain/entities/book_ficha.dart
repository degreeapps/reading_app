import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'book_ficha.g.dart';

@JsonSerializable()
class BookFicha {
  final String id;
  final String bookId;
  final String userId;
  final int rating;
  final String? summary;
  final String? learnings;
  final String? thoughts;
  final bool sharedWithTeachers;
  final bool sharedWithParents;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  const BookFicha({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.rating,
    this.summary,
    this.learnings,
    this.thoughts,
    this.sharedWithTeachers = false,
    this.sharedWithParents = false,
    this.createdAt,
    this.updatedAt,
  });

  factory BookFicha.fromJson(Map<String, dynamic> json) =>
      _$BookFichaFromJson(json);
  Map<String, dynamic> toJson() => _$BookFichaToJson(this);

  BookFicha copyWith({
    String? id,
    String? bookId,
    String? userId,
    int? rating,
    String? summary,
    String? learnings,
    String? thoughts,
    bool? sharedWithTeachers,
    bool? sharedWithParents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookFicha(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      summary: summary ?? this.summary,
      learnings: learnings ?? this.learnings,
      thoughts: thoughts ?? this.thoughts,
      sharedWithTeachers: sharedWithTeachers ?? this.sharedWithTeachers,
      sharedWithParents: sharedWithParents ?? this.sharedWithParents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _timestampFromJson(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.tryParse(timestamp);
    }
    return null;
  }

  static dynamic _timestampToJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toIso8601String();
  }
}
