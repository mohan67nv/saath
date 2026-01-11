import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

/// Explore Screen - Event discovery with swipe cards and grid view
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isGridView = false;
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All', 'Chai', 'Movies', 'Gaming', 'Books', 'Food', 'Sports', 'Music'
  ];
  
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Sunday Morning Chai',
      'emoji': '☕',
      'category': 'Chai',
      'date': 'Today, 10 AM',
      'location': 'Cubbon Park',
      'host': 'Priya S.',
      'hostVerified': true,
      'participants': 6,
      'maxParticipants': 8,
      'cost': 0, // Free event
      'description': 'Let\'s meet for chai and casual conversation. Perfect for introverts!',
    },
    {
      'id': '2',
      'title': 'Weekend Trek to Nandi Hills',
      'emoji': '🥾',
      'category': 'Movies',
      'date': 'Sat, 6 AM',
      'location': 'Nandi Hills',
      'host': 'Rahul K.',
      'hostVerified': true,
      'participants': 8,
      'maxParticipants': 12,
      'cost': 0,
      'description': 'Early morning trek with sunrise views. Bring water and snacks!',
    },
    {
      'id': '3',
      'title': 'Board Game Night',
      'emoji': '🎮',
      'category': 'Gaming',
      'date': 'Fri, 7 PM',
      'location': 'Dice n Dine, Koramangala',
      'host': 'Ankit M.',
      'hostVerified': false,
      'participants': 5,
      'maxParticipants': 8,
      'cost': 300,
      'description': 'Settlers of Catan, Ticket to Ride, and more! Beginners welcome.',
    },
    {
      'id': '4',
      'title': 'Book Club: Atomic Habits',
      'emoji': '📚',
      'category': 'Books',
      'date': 'Sun, 4 PM',
      'location': 'Atta Galatta, Koramangala',
      'host': 'Meera R.',
      'hostVerified': true,
      'participants': 4,
      'maxParticipants': 6,
      'cost': 150,
      'description': 'This month we\'re discussing Atomic Habits. Come share your insights!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _selectedCategory == 'All'
      ? _events
      : _events.where((e) => e['category'] == _selectedCategory).toList();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Category Filters
            _buildCategoryFilters(),
            
            // Content
            Expanded(
              child: _isGridView
                ? _buildGridView(filteredEvents)
                : _buildCardStack(filteredEvents),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text(
            'Explore',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // View Toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              boxShadow: AppShadows.sm,
            ),
            child: Row(
              children: [
                _ViewToggleButton(
                  icon: Icons.grid_view,
                  isSelected: _isGridView,
                  onTap: () => setState(() => _isGridView = true),
                ),
                _ViewToggleButton(
                  icon: Icons.layers,
                  isSelected: !_isGridView,
                  onTap: () => setState(() => _isGridView = false),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Filter Button
          GestureDetector(
            onTap: () => _showFilterDialog(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.lgRadius,
                boxShadow: AppShadows.sm,
              ),
              child: const Icon(Icons.tune, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
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
            Text('Filter Events', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            const Text('More filters coming soon!'),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: Row(
          children: [
            Text(event['emoji'] as String, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Join Event?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(event['date'] as String),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(event['location'] as String),
              ],
            ),
            const SizedBox(height: 12),
            if ((event['cost'] as int) > 0)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Text(
                      'Entry: ₹${event['cost']}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('You joined "${event['title']}"! 🎉'),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Join Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: AppRadius.fullRadius,
                  boxShadow: isSelected ? AppShadows.glow : AppShadows.sm,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardStack(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Stack(
        children: [
          // Background cards
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: _buildEventCard(events[0], isBackground: true),
          ),
          // Main card
          _buildEventCard(events[0])
            .animate()
            .fadeIn()
            .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, {bool isBackground = false}) {
    return GestureDetector(
      onTap: isBackground ? null : () => context.push('/event/${event['id']}'),
      child: Container(
        height: 480,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.xlRadius,
          boxShadow: isBackground ? AppShadows.md : AppShadows.lg,
        ),
        child: isBackground
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          event['emoji'] as String,
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                      // Only show price if cost > 0
                      if ((event['cost'] as int) > 0)
                        Positioned(
                          top: AppSpacing.md,
                          right: AppSpacing.md,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: AppRadius.fullRadius,
                            ),
                            child: Text(
                              '₹${event['cost']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'] as String,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        
                        // Host info
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.person,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              event['host'] as String,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (event['hostVerified'] as bool) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: AppColors.verified,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        
                        Text(
                          event['description'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        
                        // Event details
                        Row(
                          children: [
                            _EventDetail(
                              icon: Icons.calendar_today,
                              text: event['date'] as String,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            _EventDetail(
                              icon: Icons.location_on,
                              text: event['location'] as String,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        
                        // Progress bar
                        _buildParticipantsBar(
                          event['participants'] as int,
                          event['maxParticipants'] as int,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      _ActionButton(
                        icon: Icons.close,
                        color: AppColors.error,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Event skipped'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.bookmark,
                          label: 'Save',
                          color: AppColors.secondary,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.bookmark_added, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Text('Saved "${event['title']}" for later'),
                                  ],
                                ),
                                backgroundColor: AppColors.secondary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 2,
                        child: _ActionButton(
                          icon: Icons.check,
                          label: 'Join',
                          color: AppColors.success,
                          filled: true,
                          onTap: () => _showJoinConfirmation(context, event),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildParticipantsBar(int current, int max) {
    final progress = current / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.group, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              '$current/$max joined',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppRadius.fullRadius,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(
              progress >= 1 ? AppColors.error : AppColors.success,
            ),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.75,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildGridCard(event);
      },
    );
  }

  Widget _buildGridCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () => context.push('/event/${event['id']}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.lgRadius,
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  event['emoji'] as String,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['date'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${event['participants']}/${event['maxParticipants']}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No events found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try a different category',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _EventDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.label,
    required this.color,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.1),
          borderRadius: AppRadius.lgRadius,
          border: filled ? null : Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: filled ? Colors.white : color,
            ),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(
                label!,
                style: TextStyle(
                  color: filled ? Colors.white : color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
