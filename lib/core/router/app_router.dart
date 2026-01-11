import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/onboarding/screens/profile_setup_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/members/screens/members_screen.dart';
import '../../features/events/screens/create_event_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/chat/screens/chats_list_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

/// App Routes
class AppRoutes {
  static const String welcome = '/';
  static const String otp = '/otp';
  static const String profileSetup = '/profile-setup';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String members = '/members';
  static const String createEvent = '/create-event';
  static const String eventDetail = '/event/:id';
  static const String chats = '/chats';
  static const String chat = '/chat/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String otherProfile = '/user/:id';
  static const String settings = '/settings';
}

/// Shell route key for bottom navigation
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.explore,
            name: 'explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.members,
            name: 'members',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MembersScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.chats,
            name: 'chats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatsListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      
      // Full-screen routes (outside shell)
      GoRoute(
        path: AppRoutes.createEvent,
        name: 'create-event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      GoRoute(
        path: AppRoutes.eventDetail,
        name: 'event-detail',
        builder: (context, state) {
          final eventId = state.pathParameters['id'] ?? '';
          return EventDetailScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        builder: (context, state) {
          final chatId = state.pathParameters['id'] ?? '';
          final isGroup = state.extra as bool? ?? true;
          return ChatScreen(chatId: chatId, isGroupChat: isGroup);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
