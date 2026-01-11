import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Multi-step profile setup screen
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form data
  final _nameController = TextEditingController();
  int _age = 25;
  String _gender = 'Male';
  String _city = 'Bangalore';
  String? _photoUrl;
  final Set<String> _selectedInterests = {};

  final List<String> _cities = [
    'Bangalore', 'Mumbai', 'Delhi', 'Pune', 'Hyderabad', 
    'Chennai', 'Kolkata', 'Ahmedabad', 'Jaipur', 'Kochi'
  ];

  final List<Map<String, dynamic>> _interests = [
    {'name': 'Coffee', 'icon': Icons.local_cafe},
    {'name': 'Hiking', 'icon': Icons.terrain},
    {'name': 'Reading', 'icon': Icons.menu_book},
    {'name': 'Gaming', 'icon': Icons.sports_esports},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Travel', 'icon': Icons.flight},
    {'name': 'Sports', 'icon': Icons.emoji_events},
    {'name': 'Art', 'icon': Icons.palette},
    {'name': 'Tech', 'icon': Icons.laptop},
    {'name': 'Movies', 'icon': Icons.movie},
    {'name': 'Fitness', 'icon': Icons.fitness_center},
    {'name': 'Photography', 'icon': Icons.camera_alt},
    {'name': 'Cooking', 'icon': Icons.restaurant_menu},
    {'name': 'Dancing', 'icon': Icons.music_note},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      // Complete profile setup
      context.go(AppRoutes.home);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.length >= 2;
      case 1:
        return true; // Age and gender always valid
      case 2:
        return true; // Photo optional for now
      case 3:
        return _selectedInterests.length >= 3;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: _currentStep > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _previousStep,
            )
          : null,
        actions: [
          if (_currentStep < 3)
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Skip'),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            
            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoStep(),
                  _buildAgeGenderStep(),
                  _buildPhotoStep(),
                  _buildInterestsStep(),
                ],
              ),
            ),
            
            // Continue Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: GradientButton(
                onPressed: _canProceed() ? _nextStep : null,
                child: Text(
                  _currentStep == 3 ? 'Complete Profile' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: AppRadius.fullRadius,
                color: isActive 
                  ? AppColors.primary 
                  : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What\'s your name?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This is how you\'ll appear to others',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.xl),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                hintText: 'Your first name',
                prefixIcon: const Icon(Icons.person, color: AppColors.textLight),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildAgeGenderStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Age Slider
          Text(
            'Your age',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _age.toDouble(),
                  min: 18,
                  max: 80,
                  divisions: 62,
                  activeColor: AppColors.primary,
                  onChanged: (value) => setState(() => _age = value.toInt()),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Text(
                  _age.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Gender Selection
          Text(
            'Gender',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _GenderOption(
                label: 'Male',
                icon: Icons.person,
                isSelected: _gender == 'Male',
                onTap: () => setState(() => _gender = 'Male'),
              ),
              const SizedBox(width: AppSpacing.md),
              _GenderOption(
                label: 'Female',
                icon: Icons.person,
                isSelected: _gender == 'Female',
                onTap: () => setState(() => _gender = 'Female'),
              ),
              const SizedBox(width: AppSpacing.md),
              _GenderOption(
                label: 'Other',
                icon: Icons.group,
                isSelected: _gender == 'Other',
                onTap: () => setState(() => _gender = 'Other'),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // City Selection
          Text(
            'Your city',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _city,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _city = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add a photo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Show others who you are! Clear face photos work best.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          Center(
            child: GestureDetector(
              onTap: () {
                // TODO: Implement image picker
                setState(() => _photoUrl = 'placeholder');
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: AppShadows.lg,
                ),
                child: _photoUrl != null
                  ? ClipOval(
                      child: Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Tap to add',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Tips
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: AppRadius.lgRadius,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Profiles with photos get 5x more event invites!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
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

  Widget _buildInterestsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What are you into?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Select at least 3 interests to find like-minded people',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Selected count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: _selectedInterests.length >= 3
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.fullRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _selectedInterests.length >= 3
                    ? Icons.check_circle
                    : Icons.info,
                  size: 16,
                  color: _selectedInterests.length >= 3
                    ? AppColors.success
                    : AppColors.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_selectedInterests.length} selected',
                  style: TextStyle(
                    color: _selectedInterests.length >= 3
                      ? AppColors.success
                      : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Interest Grid
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest['name']);
              return _InterestChip(
                label: interest['name'] as String,
                icon: interest['icon'] as IconData,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedInterests.remove(interest['name']);
                    } else {
                      _selectedInterests.add(interest['name'] as String);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primary
            : Colors.white,
          borderRadius: AppRadius.fullRadius,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected ? AppShadows.glow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
