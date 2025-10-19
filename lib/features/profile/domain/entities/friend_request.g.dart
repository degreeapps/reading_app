// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      fromUserDisplayName: json['fromUserDisplayName'] as String,
      toUserDisplayName: json['toUserDisplayName'] as String,
      status: $enumDecode(
        _$FriendRequestStatusEnumMap,
        json['status'],
        unknownValue: FriendRequestStatus.pending,
      ),
      createdAt: FriendRequest._timestampFromJsonNonNull(json['createdAt']),
      respondedAt: FriendRequest._timestampFromJson(json['respondedAt']),
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'fromUserDisplayName': instance.fromUserDisplayName,
      'toUserDisplayName': instance.toUserDisplayName,
      'status': _$FriendRequestStatusEnumMap[instance.status]!,
      'createdAt': FriendRequest._timestampToJson(instance.createdAt),
      'respondedAt': FriendRequest._timestampToJson(instance.respondedAt),
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.pending: 'pending',
  FriendRequestStatus.accepted: 'accepted',
  FriendRequestStatus.rejected: 'rejected',
};
