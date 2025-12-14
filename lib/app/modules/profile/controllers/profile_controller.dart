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
