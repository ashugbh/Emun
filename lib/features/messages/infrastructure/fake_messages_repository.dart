import 'package:emun/core/services/fake_emun_api.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class FakeMessagesRepository implements MessagesRepository {
  FakeMessagesRepository(this._api);

  final FakeEmunApi _api;

  @override
  Future<List<Conversation>> fetchConversations() => _api.fetchConversations();

  @override
  Future<Conversation?> fetchConversation(String id) => _api.fetchConversation(id);

  @override
  Future<List<Message>> fetchMessages(String conversationId) => _api.fetchMessages(conversationId);

  @override
  Future<Message> sendMessage(String conversationId, String text) => _api.sendMessage(conversationId, text);
}
