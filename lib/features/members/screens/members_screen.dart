import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

/// Members Screen - View who viewed profile, all members, online members
class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true; // Default to grid view for better photo visibility

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Members'),
        actions: [
          // Toggle view mode
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Profile Views'),
            Tab(text: 'All Members'),
            Tab(text: 'Online'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProfileViewsTab(isGridView: _isGridView),
          _AllMembersTab(isGridView: _isGridView),
          _OnlineMembersTab(isGridView: _isGridView),
        ],
      ),
    );
  }
}

/// Profile Views Tab - Who viewed your profile
class _ProfileViewsTab extends StatelessWidget {
  final bool isGridView;
  
  const _ProfileViewsTab({required this.isGridView});
  
  // Mock data for profile views
  final List<Map<String, dynamic>> _profileViews = const [
    {'name': 'Priya S.', 'age': 26, 'time': '2 hours ago', 'verified': true, 'showPhoto': true},
    {'name': 'Rahul K.', 'age': 28, 'time': '5 hours ago', 'verified': true, 'showPhoto': false},
    {'name': 'Ananya M.', 'age': 24, 'time': 'Yesterday', 'verified': false, 'showPhoto': true},
    {'name': 'Vikram J.', 'age': 30, 'time': '2 days ago', 'verified': true, 'showPhoto': true},
  ];

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemCount: _profileViews.length,
        itemBuilder: (context, index) {
          final viewer = _profileViews[index];
          return _MemberGridCard(
            name: viewer['name'] as String,
            age: viewer['age'] as int,
            subtitle: viewer['time'] as String,
            isVerified: viewer['verified'] as bool,
            showPhoto: viewer['showPhoto'] as bool,
            isOnline: false,
          ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
        },
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _profileViews.length,
      itemBuilder: (context, index) {
        final viewer = _profileViews[index];
        return _MemberListCard(
          name: viewer['name'] as String,
          age: viewer['age'] as int,
          subtitle: 'Viewed ${viewer['time']}',
          isVerified: viewer['verified'] as bool,
          showPhoto: viewer['showPhoto'] as bool,
          isOnline: false,
        ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
      },
    );
  }
}

/// All Members Tab - Everyone in your area
class _AllMembersTab extends StatelessWidget {
  final bool isGridView;
  
  const _AllMembersTab({required this.isGridView});
  
  // Mock data for all members
  final List<Map<String, dynamic>> _members = const [
    {'name': 'Priya Sharma', 'age': 26, 'interests': 3, 'verified': true, 'showPhoto': true, 'online': true},
    {'name': 'Rahul Kumar', 'age': 28, 'interests': 2, 'verified': true, 'showPhoto': false, 'online': false},
    {'name': 'Ananya Mehta', 'age': 24, 'interests': 4, 'verified': false, 'showPhoto': true, 'online': true},
    {'name': 'Vikram Joshi', 'age': 30, 'interests': 1, 'verified': true, 'showPhoto': true, 'online': false},
    {'name': 'Neha Patel', 'age': 25, 'interests': 5, 'verified': true, 'showPhoto': true, 'online': true},
    {'name': 'Arjun Singh', 'age': 27, 'interests': 3, 'verified': false, 'showPhoto': false, 'online': false},
    {'name': 'Kavya Reddy', 'age': 23, 'interests': 4, 'verified': true, 'showPhoto': true, 'online': true},
    {'name': 'Rohan Das', 'age': 29, 'interests': 2, 'verified': true, 'showPhoto': true, 'online': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Member count
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Text(
                '${_members.length} members in your area',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Filter button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.fullRadius,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                  ),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    return _MemberGridCard(
                      name: member['name'] as String,
                      age: member['age'] as int,
                      subtitle: '${member['interests']} common',
                      isVerified: member['verified'] as bool,
                      showPhoto: member['showPhoto'] as bool,
                      isOnline: member['online'] as bool,
                    ).animate().fadeIn(delay: Duration(milliseconds: 30 * index));
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    return _MemberListCard(
                      name: member['name'] as String,
                      age: member['age'] as int,
                      subtitle: '${member['interests']} common interests',
                      isVerified: member['verified'] as bool,
                      showPhoto: member['showPhoto'] as bool,
                      isOnline: member['online'] as bool,
                    ).animate().fadeIn(delay: Duration(milliseconds: 30 * index));
                  },
                ),
        ),
      ],
    );
  }
}

/// Online Members Tab - Currently online members
class _OnlineMembersTab extends StatelessWidget {
  final bool isGridView;
  
  const _OnlineMembersTab({required this.isGridView});
  
  // Mock data for online members
  final List<Map<String, dynamic>> _onlineMembers = const [
    {'name': 'Priya Sharma', 'age': 26, 'verified': true, 'showPhoto': true, 'lastSeen': 'Active now'},
    {'name': 'Ananya Mehta', 'age': 24, 'verified': false, 'showPhoto': true, 'lastSeen': 'Active now'},
    {'name': 'Neha Patel', 'age': 25, 'verified': true, 'showPhoto': true, 'lastSeen': '2 min ago'},
    {'name': 'Kavya Reddy', 'age': 23, 'verified': true, 'showPhoto': true, 'lastSeen': '5 min ago'},
  ];

  @override
  Widget build(BuildContext context) {
    if (_onlineMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No one online right now',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check back later!',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Online count with green indicator
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_onlineMembers.length} members online',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                  ),
                  itemCount: _onlineMembers.length,
                  itemBuilder: (context, index) {
                    final member = _onlineMembers[index];
                    return _MemberGridCard(
                      name: member['name'] as String,
                      age: member['age'] as int,
                      subtitle: member['lastSeen'] as String,
                      isVerified: member['verified'] as bool,
                      showPhoto: member['showPhoto'] as bool,
                      isOnline: true,
                    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
                  },
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: _onlineMembers.length,
                  itemBuilder: (context, index) {
                    final member = _onlineMembers[index];
                    return _MemberListCard(
                      name: member['name'] as String,
                      age: member['age'] as int,
                      subtitle: member['lastSeen'] as String,
                      isVerified: member['verified'] as bool,
                      showPhoto: member['showPhoto'] as bool,
                      isOnline: true,
                    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
                  },
                ),
        ),
      ],
    );
  }
}

/// Member Grid Card - Larger photo display with action buttons inside
class _MemberGridCard extends StatelessWidget {
  final String name;
  final int age;
  final String subtitle;
  final bool isVerified;
  final bool showPhoto;
  final bool isOnline;

  const _MemberGridCard({
    required this.name,
    required this.age,
    required this.subtitle,
    required this.isVerified,
    required this.showPhoto,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          // Photo area (larger)
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Photo background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: showPhoto ? null : AppColors.primaryGradient,
                    color: showPhoto ? AppColors.primary.withValues(alpha: 0.1) : null,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: showPhoto
                      ? const Icon(Icons.person, size: 48, color: AppColors.primary)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.visibility_off, size: 24, color: Colors.white70),
                            const SizedBox(height: 4),
                            const Text(
                              'Photo\nHidden',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                ),
                // Online indicator
                if (isOnline)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                // Verified badge
                if (isVerified)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.verified,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$name, $age',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      color: isOnline ? AppColors.success : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Action buttons inside grid card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _MiniActionButton(
                        icon: Icons.waving_hand,
                        onTap: () {},
                        tooltip: 'Say Hi',
                      ),
                      const SizedBox(width: 8),
                      _MiniActionButton(
                        icon: Icons.person,
                        onTap: () {},
                        tooltip: 'View Profile',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini action button for grid cards
class _MiniActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _MiniActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Member List Card - For list view display
class _MemberListCard extends StatelessWidget {
  final String name;
  final int age;
  final String subtitle;
  final bool isVerified;
  final bool showPhoto;
  final bool isOnline;

  const _MemberListCard({
    required this.name,
    required this.age,
    required this.subtitle,
    required this.isVerified,
    required this.showPhoto,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: showPhoto ? null : AppColors.primaryGradient,
                  color: showPhoto ? AppColors.background : null,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOnline ? AppColors.success : AppColors.border,
                    width: 2,
                  ),
                ),
                child: showPhoto
                    ? ClipOval(
                        child: Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 28,
                        color: Colors.white,
                      ),
              ),
              // Photo hidden badge
              if (!showPhoto)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility_off,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              // Online indicator
              if (isOnline)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$name, $age',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: AppColors.verified,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOnline ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.waving_hand,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.person_add,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
