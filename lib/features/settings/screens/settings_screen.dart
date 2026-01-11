import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../shared/widgets/security_widgets.dart';
import '../../safety/screens/emergency_contacts_screen.dart';
import '../../safety/screens/blocked_users_screen.dart';

/// Settings Screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  bool _locationSharing = true;
  String _photoVisibility = 'group_members';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            _buildSectionTitle('Account'),
            _buildCard([
              _buildSettingTile(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _buildSettingTile(
                icon: Icons.verified,
                title: 'Verification Status',
                subtitle: 'Verified ✅',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.workspace_premium,
                title: 'Premium Subscription',
                subtitle: 'Upgrade for ₹299/month',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Privacy Section
            _buildSectionTitle('Privacy'),
            _buildCard([
              _buildDropdownTile(
                icon: Icons.image,
                title: 'Photo Visibility',
                value: _photoVisibility,
                items: {
                  'everyone': 'Everyone',
                  'group_members': 'Group Members Only',
                  'connections': 'Connections Only',
                },
                onChanged: (v) => setState(() => _photoVisibility = v),
              ),
              _buildSwitchTile(
                icon: Icons.location_on,
                title: 'Share Location',
                subtitle: 'Share location during events',
                value: _locationSharing,
                onChanged: (v) => setState(() => _locationSharing = v),
              ),
              _buildSettingTile(
                icon: Icons.person_off,
                title: 'Blocked Users',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedUsersScreen(),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Data Security Section
            _buildSectionTitle('Data Security'),
            const SecurityBadge(),
            const SizedBox(height: AppSpacing.md),
            const DataPrivacyBanner(),
            const SizedBox(height: AppSpacing.md),
            AadhaarVerificationCard(
              isVerified: false,
              onVerify: () => _showAadhaarDialog(context),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Safety Section
            _buildSectionTitle('Safety'),
            _buildCard([
              _buildSettingTile(
                icon: Icons.shield,
                title: 'Emergency Contacts',
                subtitle: 'Add trusted contacts',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmergencyContactsScreen(),
                  ),
                ),
              ),
              _buildSettingTile(
                icon: Icons.warning,
                title: 'Panic Button Settings',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.description,
                title: 'Safety Tips',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Notifications Section
            _buildSectionTitle('Notifications'),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              _buildSettingTile(
                icon: Icons.email,
                title: 'Email Preferences',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Appearance Section
            _buildSectionTitle('Appearance'),
            _buildCard([
              ListTile(
                leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: const Text('Dark Mode'),
                trailing: Switch.adaptive(
                  value: ref.watch(themeModeProvider) == ThemeMode.dark,
                  onChanged: (v) {
                    ref.read(themeModeProvider.notifier).setThemeMode(
                      v ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                  activeColor: AppColors.primary,
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Support Section
            _buildSectionTitle('Support'),
            _buildCard([
              _buildSettingTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () => _showContentSheet(context, 'Help Center', 'Find answers to common questions about using Saath.\n\n• How to create events\n• Profile verification\n• Safety features\n• Payment & refunds\n\nFor more help, contact support@saath.app'),
              ),
              _buildSettingTile(
                icon: Icons.message,
                title: 'Contact Us',
                onTap: () => _showContentSheet(context, 'Contact Us', 'Email: support@saath.app\nPhone: +91-1800-SAATH\n\nOur team is available 24/7 to assist you.'),
              ),
              _buildSettingTile(
                icon: Icons.flag,
                title: 'Report a Problem',
                onTap: () => _showContentSheet(context, 'Report a Problem', 'Help us improve Saath by reporting bugs or issues.\n\nDescribe the problem and we\'ll investigate.\n\nEmail: bugs@saath.app'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Legal Section
            _buildSectionTitle('Legal'),
            _buildCard([
              _buildSettingTile(
                icon: Icons.description,
                title: 'Terms of Service',
                onTap: () => _showContentSheet(context, 'Terms of Service', 'By using Saath, you agree to our terms:\n\n1. Be respectful to other members\n2. Attend events you RSVP to\n3. No harassment or discrimination\n4. Protect your personal information\n5. Report any safety concerns\n\nFull terms at saath.app/terms'),
              ),
              _buildSettingTile(
                icon: Icons.lock,
                title: 'Privacy Policy',
                onTap: () => _showContentSheet(context, 'Privacy Policy', 'Your privacy matters to us.\n\n• We collect only essential data\n• Your location is shared only during events\n• Aadhaar data is never stored\n• You can delete your account anytime\n\nFull policy at saath.app/privacy'),
              ),
              _buildSettingTile(
                icon: Icons.insert_drive_file,
                title: 'Community Guidelines',
                onTap: () => _showContentSheet(context, 'Community Guidelines', 'Saath Community Standards:\n\n✓ Be authentic and genuine\n✓ Respect boundaries\n✓ Keep conversations appropriate\n✓ Report inappropriate behavior\n✓ Help create a safe space\n\nViolations may result in account suspension.'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            
            // Logout
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.sm,
              ),
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go(AppRoutes.welcome);
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // App Version
            Center(
              child: Text(
                'Saath v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showAadhaarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        title: const Row(
          children: [
            Icon(Icons.badge, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Aadhaar Verification'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DigiLocker Integration Coming Soon!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              'We use DigiLocker for secure Aadhaar verification. '
              'Your Aadhaar data is never stored on our servers.',
            ),
            SizedBox(height: 12),
            Text(
              '• Zero-knowledge verification\n'
              '• Government-approved security\n'
              '• Data deleted after verification',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContentSheet(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider(height: 1, indent: 56);
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required Map<String, String> items,
    required ValueChanged<String> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.entries.map((e) {
          return DropdownMenuItem(value: e.key, child: Text(e.value));
        }).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}
