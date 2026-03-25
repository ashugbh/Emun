import 'package:equatable/equatable.dart';
import 'package:emun/features/messages/domain/entities/message.dart';

class ListingSummary extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  const ListingSummary({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, price];
}

class Conversation extends Equatable {
  final String id;
  final ListingSummary listing;
  final String otherUserName;
  final String otherUserAvatar;
  final Message lastMessage;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.listing,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.lastMessage,
    required this.unreadCount,
  });

  Conversation copyWith({
    Message? lastMessage,
    int? unreadCount,
  }) {
    return Conversation(
      id: id,
      listing: listing,
      otherUserName: otherUserName,
      otherUserAvatar: otherUserAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [id, listing, otherUserName, otherUserAvatar, lastMessage, unreadCount];
}
