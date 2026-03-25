import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/entities/message.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class ChatState extends Equatable {
  final bool isLoading;
  final Conversation? conversation;
  final List<Message> messages;
  final String? error;

  const ChatState({
    this.isLoading = false,
    this.conversation,
    this.messages = const [],
    this.error,
  });

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

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repository, this.conversationId) : super(const ChatState());

  final MessagesRepository _repository;
  final String conversationId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final conversation = await _repository.fetchConversation(conversationId);
      final messages = await _repository.fetchMessages(conversationId);
      emit(state.copyWith(isLoading: false, conversation: conversation, messages: messages));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    final message = await _repository.sendMessage(conversationId, text.trim());
    emit(state.copyWith(messages: [...state.messages, message]));
  }
}
