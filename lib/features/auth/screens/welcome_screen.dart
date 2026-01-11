import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Welcome Screen - Entry point for new users
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Navigate to OTP screen
      final phone = '+91${_phoneController.text.trim()}';
      context.push(AppRoutes.otp, extra: phone);
      
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF5F0),
              Color(0xFFFFE8E0),
              Color(0xFFFFF0EB),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.08),
                
                // Logo and Brand
                _buildLogo()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Tagline
                _buildTagline()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: size.height * 0.08),
                
                // Phone Input
                _buildPhoneInput()
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Continue Button
                _buildContinueButton()
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Features
                _buildFeatures()
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Terms
                _buildTerms()
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
  return Column(
    children: [
      // App Logo - Round with shadow
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: AppShadows.glow,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      
      // App Name
      ShaderMask(
        shaderCallback: (bounds) => AppColors.sunsetGradient.createShader(bounds),
        child: Text(
          'Saath',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
  Widget _buildTagline() {
    return Column(
      children: [
        Text(
          'Make Real Friends.',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Maybe More. ✨',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Join group activities. Meet in person.\nBuild genuine connections.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.xlRadius,
          boxShadow: AppShadows.md,
        ),
        child: TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          style: Theme.of(context).textTheme.titleMedium,
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🇮🇳',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+91',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    margin: const EdgeInsets.only(left: 12),
                    color: AppColors.divider,
                  ),
                ],
              ),
            ),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: AppRadius.xlRadius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.xlRadius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.xlRadius,
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid 10-digit number';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return GradientButton(
      onPressed: _isLoading ? null : _onContinue,
      isLoading: _isLoading,
      child: const Text(
        'Continue',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FeatureItem(
          icon: Icons.shield,
          label: 'Verified\nProfiles',
        ),
        _FeatureItem(
          icon: Icons.group,
          label: 'Group\nMeetups',
        ),
        _FeatureItem(
          icon: Icons.location_on,
          label: 'Local\nEvents',
        ),
      ],
    );
  }

  Widget _buildTerms() {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.lgRadius,
            boxShadow: AppShadows.sm,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
