import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';
import 'package:emun/features/messages/infrastructure/datasources/messages_remote_data_source.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._remoteDataSource);

  final MessagesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Conversation>> fetchConversations() =>
      _remoteDataSource.fetchConversations();

  @override
  Future<Conversation?> fetchConversation(String id) =>
      _remoteDataSource.fetchConversation(id);

  @override
  Future<List<Message>> fetchMessages(String conversationId) =>
      _remoteDataSource.fetchMessages(conversationId);

  @override
  Future<Message> sendMessage(String conversationId, String text) =>
      _remoteDataSource.sendMessage(conversationId, text);
}
