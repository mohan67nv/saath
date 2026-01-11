import '../../../core/config/supabase_config.dart';
import '../models/subscription_tier.dart';

/// Subscription Service - Manages user subscriptions
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final SupabaseConfig _supabase = SupabaseConfig();
  Subscription? _currentSubscription;

  /// Get current user's subscription
  Future<Subscription> getCurrentSubscription(String userId) async {
    if (_currentSubscription != null && _currentSubscription!.userId == userId) {
      return _currentSubscription!;
    }

    try {
      final response = await SupabaseConfig.client!
          .from('subscriptions')
          .select()
          .eq('user_id', userId)
          .single();

      _currentSubscription = Subscription.fromJson(response);
      return _currentSubscription!;
    } catch (e) {
      // No subscription found, return free tier
      return Subscription(
        id: 'free_$userId',
        userId: userId,
        tier: SubscriptionTier.free,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Get current tier
  Future<SubscriptionTier> getCurrentTier(String userId) async {
    final sub = await getCurrentSubscription(userId);
    return sub.isActive ? sub.tier : SubscriptionTier.free;
  }

  /// Check if user can create an event
  Future<bool> canCreateEvent(String userId) async {
    final tier = await getCurrentTier(userId);
    
    if (tier.eventsPerMonth == -1) return true; // Unlimited

    // Count events created this month
    final startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final count = await _supabase.client!
        .from('events')
        .select()
        .eq('creator_id', userId)
        .gte('created_at', startOfMonth.toIso8601String())
        .count();

    return (count as int) < tier.eventsPerMonth;
  }

  /// Check if user can send icebreaker
  Future<bool> canSendIcebreaker(String userId) async {
    final tier = await getCurrentTier(userId);
    
    if (tier.icebreakersPerMonth == 0) return false;
    if (tier.icebreakersPerMonth == -1) return true; // Unlimited

    // Count icebreakers sent this month
    final startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final count = await _supabase.client!
        .from('user_icebreakers_sent')
        .select()
        .eq('sender_id', userId)
        .gte('sent_at', startOfMonth.toIso8601String())
        .count();

    return (count as int) < tier.icebreakersPerMonth;
  }

  /// Check if ghost mode is enabled
  Future<bool> hasGhostMode(String userId) async {
    final tier = await getCurrentTier(userId);
    return tier.hasGhostMode;
  }

  /// Check if user can see who viewed their profile
  Future<bool> canSeeWhoViewedMe(String userId) async {
    final tier = await getCurrentTier(userId);
    return tier.canSeeWhoViewedMe;
  }

  /// Upgrade/downgrade subscription
  Future<void> updateSubscription({
    required String userId,
    required SubscriptionTier newTier,
    required String razorpaySubscriptionId,
  }) async {
    final now = DateTime.now();
    final periodEnd = DateTime(now.year, now.month + 1, now.day);

    await _supabase.client!.from('subscriptions').upsert({
      'user_id': userId,
      'plan_type': newTier.name,
      'status': 'active',
      'razorpay_subscription_id': razorpaySubscriptionId,
      'current_period_start': now.toIso8601String(),
      'current_period_end': periodEnd.toIso8601String(),
    });

    // Clear cache
    _currentSubscription = null;
  }

  /// Cancel subscription
  Future<void> cancelSubscription(String userId) async {
    await _supabase.client!
        .from('subscriptions')
        .update({'status': 'cancelled'})
        .eq('user_id', userId);

    _currentSubscription = null;
  }

  /// Clear cache (call on logout)
  void clearCache() {
    _currentSubscription = null;
  }
}
