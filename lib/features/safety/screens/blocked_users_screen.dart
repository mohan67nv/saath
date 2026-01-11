import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../services/moderation_service.dart';

/// Blocked Users Screen
class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final ModerationService _moderationService = ModerationService();
  List<String> _blockedUserIds = [];
  bool _isLoading = true;

  final String _mockUserId = 'user_123'; // TODO: Replace with actual user ID

  // Mock user data (would come from actual user service)
  final Map<String, Map<String, String>> _mockUsers = {
    'user_456': {'name': 'Fake Account', 'avatar': 'F'},
    'user_789': {'name': 'Spam User', 'avatar': 'S'},
  };

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() => _isLoading = true);
    try {
      final blockedIds = await _moderationService.getBlockedUserIds(_mockUserId);
      setState(() {
        _blockedUserIds = blockedIds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load blocked users: $e')),
        );
      }
    }
  }

  Future<void> _unblockUser(String blockedUserId) async {
    try {
      await _moderationService.unblockUser(
        userId: _mockUserId,
        blockedUserId: blockedUserId,
      );
      _loadBlockedUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User unblocked successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unblock user: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Blocked Users'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _blockedUserIds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.block,
                        size: 64,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No blocked users',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text(
                          'Users you block won\'t be able to interact with you',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textLight),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _blockedUserIds.length,
                  itemBuilder: (context, index) {
                    final userId = _blockedUserIds[index];
                    final user = _mockUsers[userId] ?? {'name': 'Unknown User', 'avatar': 'U'};

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.lgRadius,
                        boxShadow: AppShadows.sm,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              user['avatar']!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          user['name']!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Blocked'),
                        trailing: OutlinedButton(
                          onPressed: () => _unblockUser(userId),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text('Unblock'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
