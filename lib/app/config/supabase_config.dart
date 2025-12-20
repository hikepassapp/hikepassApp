import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://kckgkzmshbjbxpfwukty.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtja2drem1zaGJqYnhwZnd1a3R5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwOTU3ODEsImV4cCI6MjA4MDY3MTc4MX0.bglGCm9X1EZEH_QGQzBDKkrjJtelu-6Mbv17NzaTekc';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        // Automatically refresh token before expiry
        autoRefreshToken: true,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
