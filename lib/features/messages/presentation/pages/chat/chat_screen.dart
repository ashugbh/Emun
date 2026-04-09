import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emun/core/di/dependancy_manager.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/core/utils/formatters.dart';
import 'package:emun/features/messages/application/bloc/chat_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String? listingTitle;

  const ChatScreen({super.key, required this.conversationId, this.listingTitle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>(param1: conversationId)..load(),
      child: _ChatView(listingTitle: listingTitle),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String? listingTitle;

  const _ChatView({this.listingTitle});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final title = state.conversation?.listing.title ?? widget.listingTitle ?? 'Chat';

        return Scaffold(
          appBar: AppBar(
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          body: Column(
            children: [
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final alignment =
                              message.isMine ? Alignment.centerRight : Alignment.centerLeft;
                          final bubbleColor =
                              message.isMine ? AppColors.primary : AppColors.cardTint;
                          final textColor = message.isMine ? Colors.white : AppColors.ink;

                          return Align(
                            alignment: alignment,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: bubbleColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message.text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: textColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRelativeTime(message.sentAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: textColor.withValues(alpha: 0.7)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          final text = _controller.text.trim();
                          if (text.isEmpty) return;
                          context.read<ChatBloc>().send(text);
                          _controller.clear();
                        },
                        icon: const Icon(Icons.send),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
