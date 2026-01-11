import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Aditya Kumar');
  final _bioController = TextEditingController(
    text: 'Coffee addict ☕ | Bookworm 📚 | Weekend hiker 🥾\nLooking to make genuine friends in Bangalore!',
  );
  String _city = 'Bangalore';
  final Set<String> _interests = {'Coffee', 'Books', 'Hiking', 'Tech', 'Photography'};

  final List<String> _availableInterests = [
    'Coffee', 'Books', 'Hiking', 'Tech', 'Photography',
    'Gaming', 'Music', 'Food', 'Travel', 'Sports', 
    'Art', 'Movies', 'Fitness', 'Cooking', 'Dancing',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {
              // Save and go back
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: AppShadows.lg,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Photo Gallery
            Text(
              'Photo Gallery',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: index == 0 
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.divider,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(
                            color: index == 0 
                              ? AppColors.primary 
                              : AppColors.border,
                            style: index == 0 
                              ? BorderStyle.solid 
                              : BorderStyle.none,
                          ),
                        ),
                        child: Icon(
                          index == 0 ? Icons.person : Icons.add,
                          color: index == 0 
                            ? AppColors.primary 
                            : AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Name
            Text(
              'Name',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.sm,
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.lgRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Bio
            Text(
              'Bio',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.sm,
              ),
              child: TextField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Tell others about yourself...',
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.lgRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // City
            Text(
              'City',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
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
                  items: ['Bangalore', 'Mumbai', 'Delhi', 'Pune', 'Hyderabad'].map((c) {
                    return DropdownMenuItem(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (v) => setState(() => _city = v!),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Interests
            Text(
              'Interests',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _availableInterests.map((interest) {
                final isSelected = _interests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _interests.remove(interest);
                      } else {
                        _interests.add(interest);
                      }
                    });
                  },
                  child: Container(
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
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // Delete Account
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Delete Account',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
