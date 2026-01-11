import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Configuration
/// 
/// To use this app, you need to:
/// 1. Create a Supabase project at https://supabase.com
/// 2. Replace the placeholder values below with your project credentials
/// 3. Run the SQL migrations in supabase/migrations/

class SupabaseConfig {
  // Supabase project URL
  static const String supabaseUrl = 'https://zvmcpfycdbcmvqcjmdyy.supabase.co';
  
  // Supabase anon key (JWT format)
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2bWNwZnljZGJjbXZxY2ptZHl5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgwODE3NjMsImV4cCI6MjA4MzY1Nzc2M30.bloF7tfM5KnstpSb_S2IwA9QU2S96nWJ2JVPTKkKOHQ';
  
  // Check if Supabase is configured
  static bool get isConfigured => 
    supabaseUrl != 'https://your-project.supabase.co' &&
    supabaseAnonKey != 'your-anon-key';
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    if (!isConfigured) {
      print('⚠️ Supabase not configured. Running in demo mode.');
      return;
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }
  
  /// Get Supabase client instance
  static SupabaseClient? get client {
    if (!isConfigured) return null;
    return Supabase.instance.client;
  }
  
  /// Get current user
  static User? get currentUser => client?.auth.currentUser;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
}

/// Extension methods for Supabase operations
extension SupabaseExtensions on SupabaseClient {
  /// Profiles table reference
  SupabaseQueryBuilder get profiles => from('profiles');
  
  /// Events table reference
  SupabaseQueryBuilder get events => from('events');
  
  /// Event participants table reference
  SupabaseQueryBuilder get eventParticipants => from('event_participants');
  
  /// Group chats table reference
  SupabaseQueryBuilder get groupChats => from('group_chats');
  
  /// Group messages table reference
  SupabaseQueryBuilder get groupMessages => from('group_messages');
  
  /// Private conversations table reference
  SupabaseQueryBuilder get privateConversations => from('private_conversations');
  
  /// Private messages table reference
  SupabaseQueryBuilder get privateMessages => from('private_messages');
  
  /// User photos table reference
  SupabaseQueryBuilder get userPhotos => from('user_photos');
  
  /// User interests table reference
  SupabaseQueryBuilder get userInterests => from('user_interests');
  
  /// Connection requests table reference
  SupabaseQueryBuilder get connectionRequests => from('connection_requests');
  
  /// User reports table reference
  SupabaseQueryBuilder get userReports => from('user_reports');

  /// Emergency contacts table reference
  SupabaseQueryBuilder get emergencyContacts => from('emergency_contacts');
  
  /// User blocks table reference
  SupabaseQueryBuilder get userBlocks => from('user_blocks');
}
