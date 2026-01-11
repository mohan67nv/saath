import "../../../core/config/supabase_config.dart";

/// Moderation Service - Report and Block functionality
class ModerationService {
  /// Report a user
  Future<void> reportUser({
    required String reportingUserId,
    required String reportedUserId,
    required String reason,
    String? description,
  }) async {
    try {
      await SupabaseConfig.client!.from('user_reports').insert({
        'reporter_id': reportingUserId,
        'reported_user_id': reportedUserId,
        'reason': reason,
        'description': description,
        'status': 'pending',
        'reported_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to submit report: $e');
    }
  }

  /// Block a user
  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await SupabaseConfig.client!.from('user_blocks').insert({
        'user_id': userId,
        'blocked_user_id': blockedUserId,
        'blocked_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  /// Unblock a user
  Future<void> unblockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    try {
      await SupabaseConfig.client!
          .from('user_blocks')
          .delete()
          .eq('user_id', userId)
          .eq('blocked_user_id', blockedUserId);
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  /// Get list of blocked user IDs
  Future<List<String>> getBlockedUserIds(String userId) async {
    try {
      final response = await SupabaseConfig.client!
          .from('user_blocks')
          .select('blocked_user_id')
          .eq('user_id', userId);

      return (response as List)
          .map((e) => e['blocked_user_id'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Check if a user is blocked
  Future<bool> isUserBlocked({
    required String userId,
    required String targetUserId,
  }) async {
    try {
      final response = await SupabaseConfig.client!
          .from('user_blocks')
          .select()
          .eq('user_id', userId)
          .eq('blocked_user_id', targetUserId);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
