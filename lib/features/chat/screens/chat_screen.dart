import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Chat Screen - Individual chat room
class ChatScreen extends StatefulWidget {
  final String chatId;
  final bool isGroupChat;
  
  const ChatScreen({
    super.key, 
    required this.chatId, 
    required this.isGroupChat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender': 'Priya',
      'message': 'Hey everyone! Looking forward to meeting you all at the chai meetup! ☕',
      'time': '10:30 AM',
      'isMe': false,
    },
    {
      'id': '2',
      'sender': 'Rahul',
      'message': 'Same here! Should we meet at the main gate?',
      'time': '10:32 AM',
      'isMe': false,
    },
    {
      'id': '3',
      'sender': 'You',
      'message': 'Yes, main gate works. I\'ll be wearing a blue shirt 👕',
      'time': '10:35 AM',
      'isMe': true,
    },
    {
      'id': '4',
      'sender': 'Ananya',
      'message': 'Perfect! See you all at 10 AM tomorrow!',
      'time': '10:36 AM',
      'isMe': false,
    },
    {
      'id': '5',
      'sender': 'Priya',
      'message': 'I\'ll bring some homemade cookies! 🍪',
      'time': '10:40 AM',
      'isMe': false,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'You',
        'message': _messageController.text.trim(),
        'time': 'Just now',
        'isMe': true,
      });
      _messageController.clear();
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: widget.isGroupChat 
                  ? AppRadius.mdRadius 
                  : AppRadius.fullRadius,
              ),
              child: Center(
                child: widget.isGroupChat
                  ? const Text('☕', style: TextStyle(fontSize: 20))
                  : const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isGroupChat 
                      ? 'Sunday Morning Chai'
                      : 'Priya Sharma',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    widget.isGroupChat 
                      ? '8 members • 5 online'
                      : 'Online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.isGroupChat)
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {},
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['isMe'] as bool;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: isMe 
                      ? MainAxisAlignment.end 
                      : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe && widget.isGroupChat) ...[
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (message['sender'] as String)[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isMe 
                              ? AppColors.primary
                              : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe && widget.isGroupChat)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    message['sender'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              Text(
                                message['message'] as String,
                                style: TextStyle(
                                  color: isMe ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message['time'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe 
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppRadius.fullRadius,
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.fullRadius,
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
