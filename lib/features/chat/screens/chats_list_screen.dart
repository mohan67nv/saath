import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

/// Chats List Screen
class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupChats = [
      {
        'id': '1',
        'name': 'Sunday Morning Chai',
        'emoji': '☕',
        'lastMessage': 'Priya: Looking forward to meeting everyone! ☕',
        'time': '2m ago',
        'unread': 3,
        'members': 8,
      },
      {
        'id': '2',
        'name': 'Weekend Trek',
        'emoji': '🥾',
        'lastMessage': 'Rahul: Should we meet at 5:30 AM instead?',
        'time': '1h ago',
        'unread': 0,
        'members': 10,
      },
      {
        'id': '3',
        'name': 'Board Game Night',
        'emoji': '🎮',
        'lastMessage': 'You: I\'ll bring Catan!',
        'time': 'Yesterday',
        'unread': 0,
        'members': 6,
      },
    ];
    
    final privateChats = [
      {
        'id': 'p1',
        'name': 'Priya Sharma',
        'verified': true,
        'lastMessage': 'Hey! It was great meeting you at the chai event!',
        'time': '5m ago',
        'unread': 1,
        'isLocked': false,
      },
      {
        'id': 'p2',
        'name': 'Rahul Kumar',
        'verified': true,
        'lastMessage': 'See you at the trek!',
        'time': '3h ago',
        'unread': 0,
        'isLocked': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      'Chats',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Group Chats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(Icons.group, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Group Chats',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chat = groupChats[index];
                  return _GroupChatTile(
                    chat: chat,
                    onTap: () => context.push('/chat/${chat['id']}', extra: true),
                  );
                },
                childCount: groupChats.length,
              ),
            ),
            
            // Private Chats Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Private Chats',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chat = privateChats[index];
                  return _PrivateChatTile(
                    chat: chat,
                    onTap: () => context.push('/chat/${chat['id']}', extra: false),
                  );
                },
                childCount: privateChats.length,
              ),
            ),
            
            // Info Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: AppRadius.lgRadius,
                    border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: AppColors.info, size: 20),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Privacy First',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                            Text(
                              'Private chats are only unlocked after meeting someone at an event.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _GroupChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const _GroupChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = (chat['unread'] as int) > 0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: hasUnread 
            ? AppColors.primary.withValues(alpha: 0.05)
            : Colors.white,
          borderRadius: AppRadius.lgRadius,
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppRadius.lgRadius,
              ),
              child: Center(
                child: Text(
                  chat['emoji'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat['time'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: hasUnread ? FontWeight.w600 : null,
                            color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${chat['unread']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivateChatTile extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const _PrivateChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = (chat['unread'] as int) > 0;
    final isLocked = chat['isLocked'] as bool;
    
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isLocked 
            ? AppColors.background
            : (hasUnread ? AppColors.primary.withValues(alpha: 0.05) : Colors.white),
          borderRadius: AppRadius.lgRadius,
          boxShadow: isLocked ? null : AppShadows.sm,
          border: isLocked ? Border.all(color: AppColors.border) : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: isLocked ? null : AppColors.primaryGradient,
                    color: isLocked ? AppColors.divider : null,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: isLocked ? AppColors.textSecondary : Colors.white,
                  ),
                ),
                if (chat['verified'] as bool && !isLocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.verified,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: isLocked ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!isLocked)
                        Text(
                          chat['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isLocked)
                        const Icon(
                          Icons.lock,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      if (isLocked) const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isLocked 
                            ? 'Attend an event together to unlock'
                            : chat['lastMessage'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: hasUnread ? FontWeight.w600 : null,
                            color: isLocked 
                              ? AppColors.textLight
                              : (hasUnread ? AppColors.textPrimary : AppColors.textSecondary),
                            fontStyle: isLocked ? FontStyle.italic : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread && !isLocked)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${chat['unread']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
