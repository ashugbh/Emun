import 'package:equatable/equatable.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.isLoading = false,
    this.conversation,
    this.messages = const [],
    this.error,
  });

  final bool isLoading;
  final Conversation? conversation;
  final List<Message> messages;
  final String? error;

  ChatState copyWith({
    bool? isLoading,
    Conversation? conversation,
    List<Message>? messages,
    String? error,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, conversation, messages, error];
}
