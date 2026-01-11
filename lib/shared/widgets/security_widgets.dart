import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Security and Privacy Widgets for the Saath App
/// Emphasizes our commitment to user data protection

/// Security Trust Badge - Shows encryption status
class SecurityBadge extends StatelessWidget {
  const SecurityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.info.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'End-to-End Encrypted',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Your data is encrypted and secure',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data Privacy Banner - Shows privacy commitment
class DataPrivacyBanner extends StatelessWidget {
  final VoidCallback? onLearnMore;
  
  const DataPrivacyBanner({super.key, this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.05),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: AppColors.info, size: 20),
              const SizedBox(width: 8),
              Text(
                'Your Data, Your Control',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '✓ All data encrypted at rest and in transit\n'
            '✓ No data sold to third parties\n'
            '✓ DPDP Act 2023 compliant\n'
            '✓ Delete your data anytime',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          if (onLearnMore != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: onLearnMore,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text('Learn more about our privacy practices →'),
            ),
          ],
        ],
      ),
    );
  }
}

/// Aadhaar Verification Card - For identity verification
class AadhaarVerificationCard extends StatelessWidget {
  final bool isVerified;
  final VoidCallback? onVerify;
  
  const AadhaarVerificationCard({
    super.key,
    this.isVerified = false,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.sm,
        border: Border.all(
          color: isVerified ? AppColors.success : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isVerified 
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Icon(
                  isVerified ? Icons.verified_user : Icons.badge,
                  color: isVerified ? AppColors.success : AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aadhaar Verification',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      isVerified 
                        ? 'Verified ✓' 
                        : 'Verify for extra security',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isVerified ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isVerified)
                ElevatedButton(
                  onPressed: onVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  child: const Text('Verify', style: TextStyle(color: Colors.white)),
                ),
              if (isVerified)
                const Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.05),
              borderRadius: AppRadius.smRadius,
            ),
            child: Row(
              children: [
                const Icon(Icons.security, size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aadhaar data is encrypted and never stored locally. '
                    'We only verify and discard.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                      fontSize: 11,
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

/// Privacy First Chat Notice
class PrivacyFirstNotice extends StatelessWidget {
  const PrivacyFirstNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: AppRadius.lgRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility_off,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy First',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Private chats are only unlocked after meeting someone at an event.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Security Info Dialog
void showSecurityInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      title: Row(
        children: [
          const Icon(Icons.security, color: AppColors.success),
          const SizedBox(width: 8),
          const Text('Data Security'),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How we protect your data:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          _SecurityItem(
            icon: Icons.lock,
            title: 'AES-256 Encryption',
            subtitle: 'All data encrypted at rest',
          ),
          _SecurityItem(
            icon: Icons.sync_lock,
            title: 'TLS 1.3',
            subtitle: 'Secure data in transit',
          ),
          _SecurityItem(
            icon: Icons.fingerprint,
            title: 'Zero-Knowledge',
            subtitle: 'We cannot read your private messages',
          ),
          _SecurityItem(
            icon: Icons.gpp_good,
            title: 'DPDP Compliant',
            subtitle: 'Following Indian data protection laws',
          ),
          _SecurityItem(
            icon: Icons.delete_forever,
            title: 'Data Deletion',
            subtitle: 'Delete all your data anytime',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
