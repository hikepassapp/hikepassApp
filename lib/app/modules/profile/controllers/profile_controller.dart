import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../config/supabase_config.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = true.obs;
  var isEditing = false.obs;

  // Text Controllers for Edit Profile
  final nikController = TextEditingController();
  final namaLengkapController = TextEditingController();
  final kontakController = TextEditingController();
  final alamatController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  // Text Controllers for Change Password
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Password visibility states for Change Password
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Password validation states for Change Password
  var hasMinLengthChangePassword = false.obs;
  var hasUpperCaseChangePassword = false.obs;
  var hasLowerCaseChangePassword = false.obs;
  var hasNumberChangePassword = false.obs;

  // Loading state for Change Password
  var isChangePasswordLoading = false.obs;

  // User data
  var userId = ''.obs;
  var nik = ''.obs;
  var namaLengkap = ''.obs;
  var kontak = ''.obs;
  var countryCode = '+62'.obs;
  var tanggalLahir = ''.obs;
  var jenisKelamin = 'Laki-laki'.obs;
  var alamat = ''.obs;
  var username = ''.obs;
  var email = ''.obs;
  var avatarUrl = ''.obs;

  var termsAccepted = false.obs;
  var privacyPolicyAccepted = false.obs;
  var aboutTicketViewed = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onClose() {
    nikController.dispose();
    namaLengkapController.dispose();
    kontakController.dispose();
    alamatController.dispose();
    usernameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load user profile from Supabase
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      debugPrint('=== Loading User Profile ===');

      // Get current user
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        debugPrint('No user logged in');
        return;
      }

      userId.value = currentUser.id;
      debugPrint('User ID: ${userId.value}');

      // Get user profile from users table
      final userProfile = await _authService.getUserProfile();
      if (userProfile != null) {
        debugPrint('User Profile: $userProfile');

        email.value = userProfile['email'] ?? '';
        namaLengkap.value = userProfile['full_name'] ?? '';
        kontak.value = userProfile['phone_number'] ?? '';
        avatarUrl.value = userProfile['avatar_url'] ?? '';
        username.value =
            userProfile['email']?.split('@')[0] ??
            ''; // Use email prefix as username

        // Update text controllers
        emailController.text = email.value;
        namaLengkapController.text = namaLengkap.value;
        kontakController.text = kontak.value;
        usernameController.text = username.value;
      }

      // Get pendaki profile from pendaki_profiles table
      final pendakiProfile = await _authService.getPendakiProfile();
      if (pendakiProfile != null) {
        debugPrint('Pendaki Profile: $pendakiProfile');

        nik.value = pendakiProfile['nik'] ?? '';
        alamat.value = pendakiProfile['full_address'] ?? '';
        jenisKelamin.value = pendakiProfile['gender'] ?? 'Laki-laki';

        // Update text controllers
        nikController.text = nik.value;
        alamatController.text = alamat.value;

        // Format birth_date if exists
        if (pendakiProfile['birth_date'] != null) {
          tanggalLahir.value = pendakiProfile['birth_date'];
        }
      }

      debugPrint('=== Profile Loaded Successfully ===');
    } catch (e) {
      debugPrint('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat profil. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setGender(String gender) {
    jenisKelamin.value = gender;
  }

  void acceptTerms() {
    termsAccepted.value = true;
  }

  void viewTerms() {}

  void acceptPrivacyPolicy() {
    privacyPolicyAccepted.value = true;
  }

  void viewPrivacyPolicy() {}

  void markAboutTicketAsViewed() {
    aboutTicketViewed.value = true;
  }

  void viewAboutTicket() {}

  // Update profile in Supabase
  Future<bool> updateProfile() async {
    try {
      // Get values from controllers
      nik.value = nikController.text;
      namaLengkap.value = namaLengkapController.text;
      kontak.value = kontakController.text;
      alamat.value = alamatController.text;

      debugPrint('=== Updating Profile ===');
      debugPrint('NIK: ${nik.value}');
      debugPrint('Name: ${namaLengkap.value}');
      debugPrint('Phone: ${kontak.value}');
      debugPrint('Gender: ${jenisKelamin.value}');
      debugPrint('Address: ${alamat.value}');

      final userId = _authService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Update users table
      await SupabaseConfig.client
          .from('users')
          .update({
            'full_name': namaLengkap.value,
            'phone_number': kontak.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('Users table updated');

      // Update pendaki_profiles table
      await SupabaseConfig.client
          .from('pendaki_profiles')
          .update({
            'nik': nik.value,
            'full_name': namaLengkap.value,
            'phone_number': kontak.value,
            'gender': jenisKelamin.value,
            'full_address': alamat.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      debugPrint('Pendaki profiles table updated');
      debugPrint('=== Profile Updated Successfully ===');

      return true;
    } catch (e) {
      debugPrint('=== Update Profile Error ===');
      debugPrint('Error: $e');
      return false;
    }
  }

  // Toggle password visibility for Change Password
  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate password requirements for Change Password
  void validateChangePassword() {
    final password = newPasswordController.text;
    hasMinLengthChangePassword.value = password.length >= 8;
    hasUpperCaseChangePassword.value = password.contains(RegExp(r'[A-Z]'));
    hasLowerCaseChangePassword.value = password.contains(RegExp(r'[a-z]'));
    hasNumberChangePassword.value = password.contains(RegExp(r'[0-9]'));
  }

  // Change password
  Future<void> changePassword() async {
    try {
      // Validate inputs
      if (currentPasswordController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Password lama harus diisi',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      if (newPasswordController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Password baru harus diisi',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      if (confirmPasswordController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Konfirmasi password harus diisi',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      // Validate password requirements
      if (!hasMinLengthChangePassword.value ||
          !hasUpperCaseChangePassword.value ||
          !hasLowerCaseChangePassword.value ||
          !hasNumberChangePassword.value) {
        Get.snackbar(
          'Error',
          'Password baru harus memenuhi semua persyaratan',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      // Validate password match
      if (newPasswordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        Get.snackbar(
          'Error',
          'Password baru dan konfirmasi password tidak cocok',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      // Validate new password is different from current
      if (currentPasswordController.text.trim() ==
          newPasswordController.text.trim()) {
        Get.snackbar(
          'Error',
          'Password baru harus berbeda dari password lama',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        return;
      }

      isChangePasswordLoading.value = true;

      // Reauthenticate user with current password to verify it
      try {
        await SupabaseConfig.client.auth.signInWithPassword(
          email: email.value,
          password: currentPasswordController.text.trim(),
        );
      } catch (e) {
        debugPrint('Reauthentication error: $e');
        Get.snackbar(
          'Error',
          'Password lama salah',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          icon: Icon(Icons.error, color: Colors.red[900]),
        );
        isChangePasswordLoading.value = false;
        return;
      }

      // Update password
      await _authService.updatePassword(
        newPassword: newPasswordController.text.trim(),
      );

      // Clear controllers
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Reset validation states
      hasMinLengthChangePassword.value = false;
      hasUpperCaseChangePassword.value = false;
      hasLowerCaseChangePassword.value = false;
      hasNumberChangePassword.value = false;

      Get.back(); // Go back to profile page

      Get.snackbar(
        'Berhasil',
        'Password berhasil diubah',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.green[900]),
      );
    } catch (e) {
      debugPrint('Change password error: $e');
      Get.snackbar(
        'Error',
        'Gagal mengubah password. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        icon: Icon(Icons.error, color: Colors.red[900]),
      );
    } finally {
      isChangePasswordLoading.value = false;
    }
  }

  // Logout
  void logout() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah Anda yakin ingin keluar?',
      textConfirm: 'Ya',
      textCancel: 'Tidak',
      confirmTextColor: Colors.white,
      buttonColor: Color(0xFF26A69A),
      onConfirm: () async {
        try {
          await _authService.signOut();
          Get.back(); // Close dialog
          Get.offAllNamed('/landing-screen'); // Navigate to landing screen

          Get.snackbar(
            'Berhasil',
            'Anda telah keluar dari akun',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: Duration(seconds: 2),
          );
        } catch (e) {
          debugPrint('Logout error: $e');
          Get.back(); // Close dialog
          Get.snackbar(
            'Error',
            'Gagal logout. Silakan coba lagi.',
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
        }
      },
    );
  }
}
