// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      listing: ListingSummary.fromJson(json['listing'] as Map<String, dynamic>),
      otherUserName: json['otherUserName'] as String,
      otherUserAvatar: json['otherUserAvatar'] as String,
      lastMessage: Message.fromJson(
        json['lastMessage'] as Map<String, dynamic>,
      ),
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listing': instance.listing,
      'otherUserName': instance.otherUserName,
      'otherUserAvatar': instance.otherUserAvatar,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
    };
