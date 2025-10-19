import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'friend_request.g.dart';

enum FriendRequestStatus { pending, accepted, rejected }

@JsonSerializable()
class FriendRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String fromUserDisplayName;
  final String toUserDisplayName;
  @JsonKey(unknownEnumValue: FriendRequestStatus.pending)
  final FriendRequestStatus status;
  @JsonKey(fromJson: _timestampFromJsonNonNull, toJson: _timestampToJson)
  final DateTime createdAt;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime? respondedAt;

  const FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.fromUserDisplayName,
    required this.toUserDisplayName,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);

  FriendRequest copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? fromUserDisplayName,
    String? toUserDisplayName,
    FriendRequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      fromUserDisplayName: fromUserDisplayName ?? this.fromUserDisplayName,
      toUserDisplayName: toUserDisplayName ?? this.toUserDisplayName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
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

  static DateTime _timestampFromJsonNonNull(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }

  static dynamic _timestampToJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return dateTime.toIso8601String();
  }
}
