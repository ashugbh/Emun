import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:emun/features/messages/domain/entities/listing_summary.dart';
import 'package:emun/features/messages/domain/entities/message.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required ListingSummary listing,
    required String otherUserName,
    required String otherUserAvatar,
    required Message lastMessage,
    required int unreadCount,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
