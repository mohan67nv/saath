import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../models/subscription_tier.dart';
import '../../payments/services/razorpay_service.dart';

/// Subscription Selection Screen
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final RazorpayService _razorpayService = RazorpayService();
  final String _mockUserId = 'user_123'; // TODO: Replace with actual auth

  @override
  void initState() {
    super.initState();
    _razorpayService.initialize(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
    );
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // TODO: Get selected tier from state
    final tier = SubscriptionTier.premium;
    
    await _razorpayService.handlePaymentSuccess(
      userId: _mockUserId,
      tier: tier,
      response: response,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Welcome to Premium!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${response.message}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _subscribe(SubscriptionTier tier) async {
    if (tier == SubscriptionTier.free) return;

    await _razorpayService.openCheckout(
      userId: _mockUserId,
      tier: tier,
      userName: 'Test User', // TODO: Get from auth
      userEmail: 'test@example.com',
      userPhone: '9876543210',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Choose Your Plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text(
            'Unlock Premium Features',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Join thousands using Saath Premium',
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          
          ...SubscriptionTier.values.map((tier) {
            return _TierCard(
              tier: tier,
              onSelect: () => _subscribe(tier),
            );
          }),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final SubscriptionTier tier;
  final VoidCallback onSelect;

  const _TierCard({
    required this.tier,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = tier != SubscriptionTier.free;
    final isPopular = tier == SubscriptionTier.premium;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: isPremium ? AppColors.primary : AppColors.border,
          width: isPremium ? 2 : 1,
        ),
        boxShadow: isPremium ? AppShadows.lg : AppShadows.sm,
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  topRight: Radius.circular(AppRadius.xl),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'MOST POPULAR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(
                  tier.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tier.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      tier == SubscriptionTier.free
                          ? 'Free'
                          : '₹${tier.priceInPaise ~/ 100}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                    if (tier != SubscriptionTier.free) ...[
                      const SizedBox(width: 4),
                      const Text('/month', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                
                // Features
                ...tier.features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: isPremium ? AppColors.success : AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                const SizedBox(height: AppSpacing.lg),
                
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: tier == SubscriptionTier.free ? null : onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPremium ? AppColors.primary : AppColors.background,
                      foregroundColor: isPremium ? Colors.white : AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      elevation: 0,
                    ),
                    child: Text(
                      tier == SubscriptionTier.free ? 'Current Plan' : 'Subscribe Now',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
