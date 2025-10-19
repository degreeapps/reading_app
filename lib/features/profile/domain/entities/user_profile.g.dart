// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  uid: json['uid'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String?,
  firstName: json['firstName'] as String?,
  age: (json['age'] as num?)?.toInt(),
  grade: json['grade'] as String?,
  favoriteGenres:
      (json['favoriteGenres'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  favoriteBookIds:
      (json['favoriteBookIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  currentBookId: json['currentBookId'] as String?,
  currentBookProgress: (json['currentBookProgress'] as num?)?.toInt(),
  currentBookStartDate: UserProfile._timestampFromJson(
    json['currentBookStartDate'],
  ),
  totalBooksRead: (json['totalBooksRead'] as num?)?.toInt(),
  completedBookIds:
      (json['completedBookIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  friendIds:
      (json['friendIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt: UserProfile._timestampFromJson(json['createdAt']),
  updatedAt: UserProfile._timestampFromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'firstName': instance.firstName,
      'age': instance.age,
      'grade': instance.grade,
      'favoriteGenres': instance.favoriteGenres,
      'favoriteBookIds': instance.favoriteBookIds,
      'currentBookId': instance.currentBookId,
      'currentBookProgress': instance.currentBookProgress,
      'currentBookStartDate': UserProfile._timestampToJson(
        instance.currentBookStartDate,
      ),
      'totalBooksRead': instance.totalBooksRead,
      'completedBookIds': instance.completedBookIds,
      'friendIds': instance.friendIds,
      'createdAt': UserProfile._timestampToJson(instance.createdAt),
      'updatedAt': UserProfile._timestampToJson(instance.updatedAt),
    };
