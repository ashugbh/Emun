import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';

abstract class MessagesRepository {
  Future<List<Conversation>> fetchConversations();
  Future<Conversation?> fetchConversation(String id);
  Future<List<Message>> fetchMessages(String conversationId);
  Future<Message> sendMessage(String conversationId, String text);
}
