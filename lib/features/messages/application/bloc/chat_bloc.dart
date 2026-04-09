// ignore_for_file: invalid_use_of_visible_for_testing_member

export 'chat_event.dart';
export 'chat_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/messages/application/bloc/chat_event.dart';
import 'package:emun/features/messages/application/bloc/chat_state.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._repository, this.conversationId)
      : super(const ChatState()) {
    on<ChatLoadRequested>((event, emit) async {
      await load();
    });
    on<ChatMessageSent>((event, emit) async {
      await send(event.text);
    });
  }

  final MessagesRepository _repository;
  final String conversationId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final conversation = await _repository.fetchConversation(conversationId);
      final messages = await _repository.fetchMessages(conversationId);
      emit(
        state.copyWith(
          isLoading: false,
          conversation: conversation,
          messages: messages,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) {
      return;
    }
    final message = await _repository.sendMessage(conversationId, text.trim());
    emit(state.copyWith(messages: [...state.messages, message]));
  }
}
