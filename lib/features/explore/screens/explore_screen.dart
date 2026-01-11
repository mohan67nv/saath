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
  int _currentIndex = 0;
  final Set<String> _joinedEventIds = {'1', '2'}; // Pre-joined for demo - matches Home upcoming
  bool _showJoinedOnly = false; // New filter for joined events

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
      'category': 'Movies', // Kept generic categories for now based on previous list
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
    {
      'id': '5',
      'title': 'Badminton Match',
      'emoji': '🏸',
      'category': 'Sports',
      'date': 'Sat, 5 PM',
      'location': 'Play Arena, Sarjapur',
      'host': 'Vikram J.',
      'hostVerified': true,
      'participants': 3,
      'maxParticipants': 4,
      'cost': 200,
      'description': 'Looking for intermediate players for doubles match.',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for query parameters using GoRouterState
    try {
      final state = GoRouterState.of(context);
      final viewParam = state.uri.queryParameters['view'];
      if (viewParam == 'grid') {
        setState(() => _isGridView = true);
      } else if (viewParam == 'joined') {
        setState(() {
          _isGridView = true;
          _showJoinedOnly = true;
        });
      }
    } catch (e) {
      // Ignore if state not available
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter by category
    var filteredEvents = _selectedCategory == 'All'
      ? _events
      : _events.where((e) => e['category'] == _selectedCategory).toList();
    
    // Filter for joined only if enabled
    if (_showJoinedOnly) {
      filteredEvents = filteredEvents.where((e) => _joinedEventIds.contains(e['id'])).toList();
    }
    
    // Ensure index is valid
    if (_currentIndex >= filteredEvents.length) {
      _currentIndex = 0;
    }

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
            _showJoinedOnly ? 'My Events' : 'Explore',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Joined Toggle
          GestureDetector(
            onTap: () => setState(() => _showJoinedOnly = !_showJoinedOnly),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _showJoinedOnly ? AppColors.success : Colors.white,
                borderRadius: AppRadius.fullRadius,
                boxShadow: AppShadows.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: _showJoinedOnly ? Colors.white : AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Joined',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _showJoinedOnly ? Colors.white : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
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
    // If already joined, do nothing or show already joined message
    if (_joinedEventIds.contains(event['id'])) {
      return;
    }

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
              setState(() {
                _joinedEventIds.add(event['id']);
                _isSlidingOut = true; // Advance to next card like X button
              });
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
              onTap: () => setState(() {
                _selectedCategory = category;
                _currentIndex = 0; // Reset index when category changes
              }),
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

  bool _isSlidingOut = false;

  Widget _buildCardStack(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return _buildEmptyState();
    }
    
    // Cycle logic
    final currentEvent = events[_currentIndex];
    final nextEventIndex = (_currentIndex + 1) % events.length;
    final nextEvent = events[nextEventIndex];
    
    // Don't show background card if only 1 event
    final showBackground = events.length > 1;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Stack(
        children: [
          // Background card (Next Event)
          if (showBackground)
            _buildBackgroundCard(nextEvent),
          
          // Main card (Current Event)
          _buildForegroundCard(currentEvent),
        ],
      ),
    );
  }

  Widget _buildBackgroundCard(Map<String, dynamic> event) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child: Transform.translate(
          offset: const Offset(0, 20), // Start slightly down
          child: _buildEventCard(event, isBackground: true)
            .animate(
              target: _isSlidingOut ? 1 : 0,
            )
            .scaleXY(
              begin: 0.92, // Deep in background
              end: 1.0, // Comes to front
              duration: 200.ms,
              curve: Curves.easeOut,
            )
            .moveY(
              begin: 0,
              end: -20, // Move up to align with foreground
              duration: 200.ms,
              curve: Curves.easeOut,
            ),
        ),
      ),
    );
  }

  Widget _buildForegroundCard(Map<String, dynamic> event) {
    // Only animate exit when _isSlidingOut is true
    if (_isSlidingOut) {
      return _buildEventCard(event)
        .animate(
          onComplete: (controller) {
            setState(() {
              _currentIndex = (_currentIndex + 1) % _events.length;
              _isSlidingOut = false;
            });
          },
        )
        .slideX(
          begin: 0,
          end: -1.5,
          duration: 300.ms,
          curve: Curves.easeIn,
        )
        .rotate(
          begin: 0,
          end: -0.15,
          duration: 300.ms,
          curve: Curves.easeIn,
        );
    }
    
    // Normal state - just show the card with a subtle entrance
    return _buildEventCard(event)
      .animate(key: ValueKey(event['id']))
      .fadeIn(duration: 200.ms);
  }

  Widget _buildEventCard(Map<String, dynamic> event, {bool isBackground = false}) {
    final isJoined = _joinedEventIds.contains(event['id']);

    return GestureDetector(
      onTap: isBackground ? null : () => context.push('/event/${event['id']}'),
      child: Container(
        height: 520, // Increased height for better aspect ratio
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.xlRadius,
          boxShadow: isBackground 
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] 
              : AppShadows.lg,
        ),
        child: isBackground
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: AppRadius.xlRadius,
              ),
              child: Center(
                 child: Text(
                   event['emoji'] as String, 
                   style: TextStyle(fontSize: 80, color: AppColors.textLight.withValues(alpha: 0.2)),
                 ),
              ),
            ) 
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image placeholder
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      event['emoji'] as String,
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
                
                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'] as String,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                         Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.person, size: 14, color: Colors.white),
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
                              const Icon(Icons.verified, size: 14, color: AppColors.verified),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          event['description'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              event['date'] as String,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                            const Spacer(),
                            const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              event['location'] as String,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Participants Bar
                        _buildParticipantsBar(event['participants'] as int, event['maxParticipants'] as int),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${event['participants']} going',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${(event['cost'] as int) > 0 ? "₹${event['cost']}" : "Free"}',
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ],
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
                      // X Button - Skip to next event
                      _ActionButton(
                        icon: Icons.close,
                        color: AppColors.error,
                        onTap: () {
                          if (!_isSlidingOut) {
                            setState(() => _isSlidingOut = true);
                          }
                        },
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Save Button
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.bookmark,
                          label: 'Save',
                          color: AppColors.secondary,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Event Saved!"), duration: Duration(seconds: 1)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Join Button
                      Expanded(
                        flex: 2,
                        child: _ActionButton(
                          icon: isJoined ? Icons.check_circle : Icons.check,
                          label: isJoined ? 'Joined' : 'Join',
                          color: AppColors.success,
                          filled: true,
                          // If joined, verify logic, else show confirmation
                          onTap: isJoined ? () {} : () => _showJoinConfirmation(context, event),
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
        ClipRRect(
          borderRadius: AppRadius.fullRadius,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(
              progress >= 1 ? AppColors.error : AppColors.success,
            ),
            minHeight: 6,
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
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.65, // Taller cards to fit grid of photos
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
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Participant Photo Grid - takes most space
            AspectRatio(
              aspectRatio: 1.1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _ParticipantGrid(count: event['participants'] as int),
              ),
            ),
            
            // Details - compact, no flex
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                    children: [
                       Text(
                        event['emoji'] as String,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['title'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                   ),
                  const SizedBox(height: 4),
                  Text(
                    event['date'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.group, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${event['participants']} Going',
                        style: TextStyle(
                           fontSize: 11, 
                           fontWeight: FontWeight.w600,
                           color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                           color: AppColors.success.withValues(alpha: 0.1),
                           borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (event['cost'] as int) == 0 ? 'FREE' : '₹${event['cost']}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.lgRadius,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;

  const _ActionButton({
    required this.icon,
    this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: filled ? color : Colors.white,
          borderRadius: AppRadius.fullRadius,
          border: filled ? null : Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: filled ? AppShadows.md : null,
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
              const SizedBox(width: 8),
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

class _ParticipantGrid extends StatelessWidget {
  final int count;

  const _ParticipantGrid({required this.count});

  @override
  Widget build(BuildContext context) {
    // Calculate grid dimensions based on count
    int cols, rows;
    if (count <= 4) {
      cols = 2;
      rows = 2;
    } else if (count <= 6) {
      cols = 3;
      rows = 2;
    } else {
      cols = 3;
      rows = 3;
    }
    
    final displayCount = (cols * rows).clamp(1, count);
    
    return Container(
      color: Colors.grey[100],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / cols;
          final cellHeight = constraints.maxHeight / rows;
          
          return Wrap(
            children: List.generate(displayCount, (index) {
              final color = Colors.primaries[index % Colors.primaries.length];
              return SizedBox(
                width: cellWidth,
                height: cellHeight,
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: color,
                      size: cellHeight * 0.5,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
