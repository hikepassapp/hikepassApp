import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AuthService extends GetxService {
  final _supabase = SupabaseConfig.client;

  // Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Get pendaki specific profile
  Future<Map<String, dynamic>?> getPendakiProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('pendaki_profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error getting pendaki profile: $e');
      return null;
    }
  }

  // Register new user
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String userType,
    String? phoneNumber,
  }) async {
    try {
      print('=== Starting SignUp ===');
      print('Email: $email');
      print('User Type: $userType');

      // Step 1: Create auth user (trigger will auto-create users & pendaki_profiles)
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      print('=== Auth Response ===');
      print('User ID: ${response.user?.id}');
      print('User Email: ${response.user?.email}');

      if (response.user != null) {
        // Step 2: Update users table with additional info
        print('=== Updating User Profile ===');
        await _supabase
            .from('users')
            .update({
              'full_name': fullName,
              'phone_number': phoneNumber,
              'user_type': userType,
            })
            .eq('id', response.user!.id);

        print('=== User Profile Updated Successfully ===');
      }

      return response;
    } catch (e) {
      print('=== SignUp Error ===');
      print('Error: $e');
      rethrow;
    }
  }

  // Update pendaki profile
  Future<void> updatePendakiProfile({
    required String nik,
    required String emergencyContact,
    required String emergencyPhone,
    String? bloodType,
    String? healthConditions,
    String? hikingExperience,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase
          .from('pendaki_profiles')
          .update({
            'nik': nik,
            'emergency_contact': emergencyContact,
            'emergency_phone': emergencyPhone,
            'blood_type': bloodType,
            'health_conditions': healthConditions,
            'hiking_experience': hikingExperience,
          })
          .eq('id', userId);
    } catch (e) {
      print('Error updating pendaki profile: $e');
      rethrow;
    }
  }

  // Login with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Send OTP to email
  Future<void> sendOtpToEmail({required String email}) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false, // Don't create user, just send OTP
      );
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP
  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Reset password (send reset email)
  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Update password
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
