import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';
import 'package:emun/features/messages/domain/repositories/messages_repository.dart';

class InboxState extends Equatable {
  final bool isLoading;
  final List<Conversation> conversations;
  final String? error;

  const InboxState({
    this.isLoading = false,
    this.conversations = const [],
    this.error,
  });

  InboxState copyWith({
    bool? isLoading,
    List<Conversation>? conversations,
    String? error,
  }) {
    return InboxState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, conversations, error];
}

class InboxCubit extends Cubit<InboxState> {
  InboxCubit(this._repository) : super(const InboxState());

  final MessagesRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final conversations = await _repository.fetchConversations();
      emit(state.copyWith(isLoading: false, conversations: conversations));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }
}
