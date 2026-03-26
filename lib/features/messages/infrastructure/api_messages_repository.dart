import 'package:emun/core/services/backend_emun_api.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class ApiMessagesRepository implements MessagesRepository {
  ApiMessagesRepository(this._api);

  final BackendEmunApi _api;

  @override
  Future<List<Conversation>> fetchConversations() => _api.fetchConversations();

  @override
  Future<Conversation?> fetchConversation(String id) =>
      _api.fetchConversation(id);

  @override
  Future<List<Message>> fetchMessages(String conversationId) =>
      _api.fetchMessages(conversationId);

  @override
  Future<Message> sendMessage(String conversationId, String text) =>
      _api.sendMessage(conversationId, text);
}
