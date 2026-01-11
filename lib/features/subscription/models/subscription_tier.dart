/// Subscription tier enumeration
enum SubscriptionTier {
  free,
  premium,
  premiumPlus;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.premiumPlus:
        return 'Premium+';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionTier.free:
        return 'Perfect for getting started';
      case SubscriptionTier.premium:
        return 'Unlock exclusive features';
      case SubscriptionTier.premiumPlus:
        return 'Ultimate experience with priority support';
    }
  }

  int get priceInPaise {
    switch (this) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.premium:
        return 29900; // ₹299
      case SubscriptionTier.premiumPlus:
        return 49900; // ₹499
    }
  }

  String get priceDisplay {
    if (this == SubscriptionTier.free) return 'Free';
    return '₹${priceInPaise ~/ 100}/month';
  }

  // Feature limits
  int get eventsPerMonth {
    switch (this) {
      case SubscriptionTier.free:
        return 5;
      case SubscriptionTier.premium:
      case SubscriptionTier.premiumPlus:
        return -1; // Unlimited
    }
  }

  int get icebreakersPerMonth {
    switch (this) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.premium:
        return 10;
      case SubscriptionTier.premiumPlus:
        return -1; // Unlimited
    }
  }

  bool get hasGhostMode {
    return this != SubscriptionTier.free;
  }

  bool get canSeeWhoViewedMe {
    return this != SubscriptionTier.free;
  }

  bool get isAdFree {
    return this != SubscriptionTier.free;
  }

  bool get hasPrioritySupport {
    return this == SubscriptionTier.premiumPlus;
  }

  List<String> get features {
    switch (this) {
      case SubscriptionTier.free:
        return [
          'Create up to 5 events per month',
          'Join unlimited events',
          'Basic profile features',
          'Connect with verified users',
        ];
      case SubscriptionTier.premium:
        return [
          'Unlimited events',
          '10 icebreaker messages/month',
          'Ghost mode',
          'See who viewed your profile',
          'Ad-free experience',
          'Premium badge',
        ];
      case SubscriptionTier.premiumPlus:
        return [
          'Everything in Premium',
          'Unlimited icebreakers',
          'Priority support (24h response)',
          'Featured profile placement',
          'Advanced filters',
          'Early access to new features',
        ];
    }
  }
}

/// Subscription model
class Subscription {
  final String id;
  final String userId;
  final SubscriptionTier tier;
  final String status; // active, cancelled, expired
  final String? razorpaySubscriptionId;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.tier,
    required this.status,
    this.razorpaySubscriptionId,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == 'active' && (currentPeriodEnd?.isAfter(DateTime.now()) ?? false);

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.name == json['plan_type'],
        orElse: () => SubscriptionTier.free,
      ),
      status: json['status'],
      razorpaySubscriptionId: json['razorpay_subscription_id'],
      currentPeriodStart: json['current_period_start'] != null
          ? DateTime.parse(json['current_period_start'])
          : null,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.parse(json['current_period_end'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_type': tier.name,
      'status': status,
      'razorpay_subscription_id': razorpaySubscriptionId,
      'current_period_start': currentPeriodStart?.toIso8601String(),
      'current_period_end': currentPeriodEnd?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
