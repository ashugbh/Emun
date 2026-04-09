import 'package:equatable/equatable.dart';
import 'package:emun/features/messages/domain/entities/conversation.dart';

class InboxState extends Equatable {
  const InboxState({
    this.isLoading = false,
    this.conversations = const [],
    this.error,
  });

  final bool isLoading;
  final List<Conversation> conversations;
  final String? error;

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
