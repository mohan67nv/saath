import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

import '../../../core/config/razorpay_config.dart';
import '../../subscription/models/subscription_tier.dart';
import '../../subscription/services/subscription_service.dart';

/// Razorpay Payment Service
class RazorpayService {
  late Razorpay _razorpay;
  final SubscriptionService _subscriptionService = SubscriptionService();

  void initialize({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
      onSuccess(response as PaymentSuccessResponse);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      onFailure(response as PaymentFailureResponse);
    });
  }

  /// Create and open Razorpay checkout
  Future<void> openCheckout({
    required String userId,
    required SubscriptionTier tier,
    required String userName,
    required String userEmail,
    required String userPhone,
  }) async {
    if (!RazorpayConfig.isConfigured) {
      throw Exception('Razorpay not configured. Please add your API keys.');
    }

    final options = {
      'key': RazorpayConfig.keyId,
      'amount': tier.priceInPaise, // Amount in paise
      'currency': RazorpayConfig.currency,
      'name': RazorpayConfig.companyName,
      'description': '${tier.displayName} Subscription',
      'image': RazorpayConfig.companyLogo,
      'prefill': {
        'contact': userPhone,
        'email': userEmail,
        'name': userName,
      },
      'theme': {
        'color': '#FF6B35', // AppColors.primary
      },
      'notes': {
        'user_id': userId,
        'tier': tier.name,
      },
      'subscription_card_change': false,
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
      rethrow;
    }
  }

  /// Handle successful payment
  Future<void> handlePaymentSuccess({
    required String userId,
    required SubscriptionTier tier,
    required PaymentSuccessResponse response,
  }) async {
    // Store payment transaction
    // TODO: Call Supabase Edge Function to verify payment signature
    
    // Update subscription
    await _subscriptionService.updateSubscription(
      userId: userId,
      newTier: tier,
      razorpaySubscriptionId: response.paymentId ?? '',
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
