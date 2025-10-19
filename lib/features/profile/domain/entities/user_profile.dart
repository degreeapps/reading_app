import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String uid;
  final String displayName;
  final String? photoURL;
  final String? firstName;
  final int? age;
  final String? grade;
  final List<String>? favoriteGenres;
  final List<String>? favoriteBookIds;
  final String? currentBookId;
  final int? currentBookProgress;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? currentBookStartDate;
  final int? totalBooksRead;
  final List<String>? completedBookIds;
  final List<String>? friendIds;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.displayName,
    this.photoURL,
    this.firstName,
    this.age,
    this.grade,
    this.favoriteGenres,
    this.favoriteBookIds,
    this.currentBookId,
    this.currentBookProgress,
    this.currentBookStartDate,
    this.totalBooksRead,
    this.completedBookIds,
    this.friendIds,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? photoURL,
    String? firstName,
    int? age,
    String? grade,
    List<String>? favoriteGenres,
    List<String>? favoriteBookIds,
    String? currentBookId,
    int? currentBookProgress,
    DateTime? currentBookStartDate,
    int? totalBooksRead,
    List<String>? completedBookIds,
    List<String>? friendIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      firstName: firstName ?? this.firstName,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      favoriteBookIds: favoriteBookIds ?? this.favoriteBookIds,
      currentBookId: currentBookId ?? this.currentBookId,
      currentBookProgress: currentBookProgress ?? this.currentBookProgress,
      currentBookStartDate: currentBookStartDate ?? this.currentBookStartDate,
      totalBooksRead: totalBooksRead ?? this.totalBooksRead,
      completedBookIds: completedBookIds ?? this.completedBookIds,
      friendIds: friendIds ?? this.friendIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Método específico para limpiar el libro actual (establecer null explícitamente)
  UserProfile copyWithClearCurrentBook({
    String? uid,
    String? displayName,
    String? photoURL,
    String? firstName,
    int? age,
    String? grade,
    List<String>? favoriteGenres,
    List<String>? favoriteBookIds,
    int? totalBooksRead,
    List<String>? completedBookIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      firstName: firstName ?? this.firstName,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      favoriteBookIds: favoriteBookIds ?? this.favoriteBookIds,
      currentBookId: null, // Explícitamente null
      currentBookProgress: null, // Explícitamente null
      currentBookStartDate: null, // Explícitamente null
      totalBooksRead: totalBooksRead ?? this.totalBooksRead,
      completedBookIds: completedBookIds ?? this.completedBookIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.uid == uid &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.firstName == firstName &&
        other.age == age &&
        other.grade == grade &&
        other.favoriteGenres == favoriteGenres &&
        other.favoriteBookIds == favoriteBookIds &&
        other.currentBookId == currentBookId &&
        other.currentBookProgress == currentBookProgress &&
        other.currentBookStartDate == currentBookStartDate &&
        other.totalBooksRead == totalBooksRead &&
        other.completedBookIds == completedBookIds &&
        other.friendIds == friendIds &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      uid,
      displayName,
      photoURL,
      firstName,
      age,
      grade,
      favoriteGenres,
      favoriteBookIds,
      currentBookId,
      currentBookProgress,
      currentBookStartDate,
      totalBooksRead,
      completedBookIds,
      friendIds,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, displayName: $displayName, photoURL: $photoURL, firstName: $firstName, age: $age, grade: $grade, favoriteGenres: $favoriteGenres, favoriteBookIds: $favoriteBookIds, currentBookId: $currentBookId, currentBookProgress: $currentBookProgress, currentBookStartDate: $currentBookStartDate, totalBooksRead: $totalBooksRead, completedBookIds: $completedBookIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  // Métodos de conversión para Timestamp de Firestore
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
