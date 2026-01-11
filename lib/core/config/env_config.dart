// Supabase Configuration - Secure Storage
// These keys should be stored in environment variables for production

class SupabaseConfig {
  // Supabase project URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://zvmcpfycdbcmvqcjmdyy.supabase.co',
  );
  
  // Supabase anon key (public, safe to expose in client)
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2bWNwZnljZGJjbXZxY2ptZHl5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgwODE3NjMsImV4cCI6MjA4MzY1Nzc2M30.bloF7tfM5KnstpSb_S2IwA9QU2S96nWJ2JVPTKkKOHQ',
  );
  
  // Check if Supabase is configured
  static bool get isConfigured => 
    supabaseUrl.isNotEmpty && 
    supabaseAnonKey.isNotEmpty &&
    supabaseUrl != 'https://your-project.supabase.co';
}
