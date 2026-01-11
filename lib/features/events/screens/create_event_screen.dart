import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Create Event Screen - Multi-step event creation
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form Data
  String? _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  int _duration = 120;
  int _maxParticipants = 8;
  int _costPerPerson = 0;
  String _visibility = 'public';
  String _location = '';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Chai & Chat', 'emoji': '☕', 'icon': Icons.local_cafe},
    {'name': 'Hiking', 'emoji': '🥾', 'icon': Icons.terrain},
    {'name': 'Board Games', 'emoji': '🎮', 'icon': Icons.sports_esports},
    {'name': 'Book Club', 'emoji': '📚', 'icon': Icons.menu_book},
    {'name': 'Food Walk', 'emoji': '🍔', 'icon': Icons.restaurant},
    {'name': 'Art & Craft', 'emoji': '🎨', 'icon': Icons.palette},
    {'name': 'Music Jam', 'emoji': '🎵', 'icon': Icons.music_note},
    {'name': 'Sports', 'emoji': '⚽', 'icon': Icons.emoji_events},
    {'name': 'Networking', 'emoji': '💼', 'icon': Icons.work},
    {'name': 'Custom', 'emoji': '✨', 'icon': Icons.auto_awesome},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
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
      _createEvent();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _createEvent() {
    // TODO: Implement API call
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                size: 40,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Event Created!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your event is now live. Share it with friends!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Share Event'),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _titleController.text.length >= 4;
      case 2:
        return _location.isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  String? _getTitleError() {
    if (_titleController.text.isEmpty) return null;
    if (_titleController.text.length < 4) {
      return 'Event name must be at least 4 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: _previousStep,
        ),
        title: Text(
          'Create Event',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryStep(),
                _buildDetailsStep(),
                _buildLocationStep(),
                _buildSettingsStep(),
              ],
            ),
          ),
          
          // Continue Button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: GradientButton(
              onPressed: _canProceed() ? _nextStep : null,
              child: Text(
                _currentStep == 3 ? 'Create Event' : 'Continue',
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
    );
  }

  Widget _buildProgressIndicator() {
    final steps = ['Category', 'Details', 'Location', 'Settings'];
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isActive 
                            ? AppColors.primary 
                            : AppColors.divider,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isActive 
                          ? AppColors.primary 
                          : AppColors.divider,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isActive 
                                  ? Colors.white 
                                  : AppColors.textSecondary,
                              ),
                            ),
                      ),
                    ),
                    if (index < 3)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < _currentStep 
                            ? AppColors.primary 
                            : AppColors.divider,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are we doing?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose a category for your event',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: AppSpacing.lg),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category['name'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                    borderRadius: AppRadius.lgRadius,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected ? AppShadows.glow : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category['emoji'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                            ? AppColors.primary 
                            : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Title
          _buildLabel('Event Title'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g., Sunday Morning Chai at Cubbon Park',
                errorText: _getTitleError(),
                helperText: _titleController.text.isEmpty 
                  ? 'Minimum 4 characters required' 
                  : null,
                helperStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Description
          _buildLabel('Description'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tell people what to expect...',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Date & Time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Date'),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.lgRadius,
                          boxShadow: AppShadows.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, size: 18, color: AppColors.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Time'),
                    GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) setState(() => _selectedTime = time);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.lgRadius,
                          boxShadow: AppShadows.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 18, color: AppColors.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime.format(context),
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Duration & Participants
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Duration'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.lgRadius,
                        boxShadow: AppShadows.sm,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _duration,
                          isExpanded: true,
                          items: [60, 90, 120, 180, 240].map((d) {
                            return DropdownMenuItem(
                              value: d,
                              child: Text('${d ~/ 60}h ${d % 60 > 0 ? "${d % 60}m" : ""}'),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _duration = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Max People'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.lgRadius,
                        boxShadow: AppShadows.sm,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _maxParticipants,
                          isExpanded: true,
                          items: [4, 6, 8, 10, 12, 15, 20].map((n) {
                            return DropdownMenuItem(
                              value: n,
                              child: Text('$n people'),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() => _maxParticipants = v!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where are we meeting?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Location Search
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _location = v),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Popular Locations
          Text(
            'Popular Locations',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          
          ...[
            {'name': 'Cubbon Park', 'area': 'MG Road, Bangalore'},
            {'name': 'Third Wave Coffee', 'area': 'Koramangala'},
            {'name': 'Starbucks', 'area': 'Indiranagar'},
            {'name': 'Dice n Dine', 'area': 'HSR Layout'},
          ].map((loc) {
            return GestureDetector(
              onTap: () => setState(() => _location = loc['name']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _location == loc['name']
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(
                    color: _location == loc['name']
                      ? AppColors.primary
                      : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _location == loc['name']
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc['name']!,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          loc['area']!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Cost
          _buildLabel('Estimated Cost per Person'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0',
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: AppRadius.lgRadius,
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => _costPerPerson = int.tryParse(v) ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Visibility Options
          ...[
            {'value': 'public', 'title': 'Public', 'subtitle': 'Anyone can join', 'icon': Icons.public},
            {'value': 'verified', 'title': 'Verified Only', 'subtitle': 'Only verified users', 'icon': Icons.verified},
            {'value': 'women', 'title': 'Women Only', 'subtitle': 'Verified women only', 'icon': Icons.group},
            {'value': 'invite', 'title': 'Invite Only', 'subtitle': 'By invitation only', 'icon': Icons.lock},
          ].map((option) {
            final isSelected = _visibility == option['value'];
            return GestureDetector(
              onTap: () => setState(() => _visibility = option['value'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.background,
                        borderRadius: AppRadius.mdRadius,
                      ),
                      child: Icon(
                        option['icon'] as IconData,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'] as String,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          Text(
                            option['subtitle'] as String,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            );
          }),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Summary Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppRadius.lgRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _titleController.text.isNotEmpty 
                    ? _titleController.text 
                    : 'Untitled Event',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month} at ${_selectedTime.format(context)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      _location.isNotEmpty ? _location : 'No location',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
