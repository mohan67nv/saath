import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';

/// Main Saath App Widget
class SaathApp extends ConsumerWidget {
  const SaathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'Saath',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      
      // Router configuration
      routerConfig: router,
      
      // Scroll behavior for web
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
