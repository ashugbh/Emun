sealed class ChatEvent {
  const ChatEvent();
}

final class ChatLoadRequested extends ChatEvent {
  const ChatLoadRequested();
}

final class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.text);

  final String text;
}
