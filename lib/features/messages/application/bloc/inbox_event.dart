sealed class InboxEvent {
  const InboxEvent();
}

final class InboxLoadRequested extends InboxEvent {
  const InboxLoadRequested();
}
