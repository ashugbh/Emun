import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/core/theme/app_colors.dart';
import 'package:emun/core/utils/formatters.dart';
import 'package:emun/core/widgets/empty_state.dart';
import 'package:emun/features/messages/application/inbox_cubit.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InboxCubit, InboxState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.conversations.isEmpty) {
          return const EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'No conversations yet',
            subtitle: 'Start a chat from any listing to connect with sellers.',
          );
        }

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Messages',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ...state.conversations.map(
                (conversation) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(conversation.otherUserAvatar),
                  ),
                  title: Text(
                    conversation.otherUserName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    conversation.lastMessage.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatRelativeTime(conversation.lastMessage.sentAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.accent,
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => context.pushNamed(
                    RouteName.chat,
                    pathParameters: {'id': conversation.id},
                    extra: conversation.listing.title,
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
