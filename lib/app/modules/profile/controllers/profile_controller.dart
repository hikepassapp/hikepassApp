import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/auth_service.dart';
import '../../../config/supabase_config.dart';
import '../../../services/error_handling_service.dart';
import '../../../services/image_optimization_service.dart';
import '../../../utils/validators.dart';

class ProfileController extends GetxController {
  late final AuthService _authService;
  late final ErrorHandlingService _errorService;
  final _supabase = SupabaseConfig.client;
  final ImagePicker _picker = ImagePicker();

  var isLoading = true.obs;
  var isEditing = false.obs;
  var isUploadingAvatar = false.obs;

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
    _authService = Get.find<AuthService>();
    _errorService = Get.find<ErrorHandlingService>();
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
      nik.value = nikController.text.trim();
      namaLengkap.value = namaLengkapController.text.trim();
      kontak.value = kontakController.text.trim();
      alamat.value = alamatController.text.trim();

      // Validate inputs
      final nikError = Validators.validateNIK(nik.value);
      if (nikError != null) {
        Get.snackbar(
          'Validasi Gagal',
          nikError,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

      final nameError = Validators.validateName(namaLengkap.value);
      if (nameError != null) {
        Get.snackbar(
          'Validasi Gagal',
          nameError,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

      final phoneError = Validators.validatePhoneNumber(kontak.value);
      if (phoneError != null) {
        Get.snackbar(
          'Validasi Gagal',
          phoneError,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

      final addressError = Validators.validateAddress(alamat.value);
      if (addressError != null) {
        Get.snackbar(
          'Validasi Gagal',
          addressError,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

      if (jenisKelamin.value.isEmpty) {
        Get.snackbar(
          'Validasi Gagal',
          'Pilih jenis kelamin',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return false;
      }

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

      // Update users table with retry
      await _errorService.retryOperation(
        operation: () => SupabaseConfig.client
            .from('users')
            .update({
              'full_name': namaLengkap.value,
              'phone_number': kontak.value,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId),
        maxRetries: 3,
      );

      debugPrint('Users table updated');

      // Update pendaki_profiles table with retry
      await _errorService.retryOperation(
        operation: () => SupabaseConfig.client
            .from('pendaki_profiles')
            .update({
              'nik': nik.value,
              'full_name': namaLengkap.value,
              'phone_number': kontak.value,
              'gender': jenisKelamin.value,
              'full_address': alamat.value,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId),
        maxRetries: 3,
      );

      debugPrint('Pendaki profiles table updated');
      debugPrint('=== Profile Updated Successfully ===');

      return true;
    } catch (e) {
      debugPrint('=== Update Profile Error ===');
      debugPrint('Error: $e');

      _errorService.handleError(e);
      Get.snackbar(
        'Error',
        'Gagal memperbarui profil. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );

      return false;
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await uploadAvatar(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Take photo with camera
  Future<void> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await uploadAvatar(File(image.path));
      }
    } catch (e) {
      debugPrint('Error taking photo: $e');
      Get.snackbar(
        'Error',
        'Gagal mengambil foto',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Upload avatar to Supabase Storage
  Future<void> uploadAvatar(File imageFile) async {
    try {
      isUploadingAvatar.value = true;

      final userId = _authService.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      debugPrint('=== Uploading Avatar ===');

      // Validate image file
      final fileSize = await imageFile.length();
      final validationError = Validators.validateImageFile(
        imageFile.path,
        fileSize,
      );
      if (validationError != null) {
        Get.snackbar(
          'Error',
          validationError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      // Optimize image before upload
      debugPrint('Optimizing image...');
      final optimizedImage = await ImageOptimizationService.optimizeImage(
        imageFile: imageFile,
      );
      if (optimizedImage == null) {
        Get.snackbar(
          'Error',
          'Gagal mengoptimalkan gambar',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }
      final optimizedFileSize = await optimizedImage.length();
      debugPrint('Image optimized: ${optimizedFileSize / 1024 / 1024} MB');

      // Generate unique filename
      final fileExt = optimizedImage.path.split('.').last;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      debugPrint('File path: $filePath');

      // Delete old avatar if exists
      if (avatarUrl.value.isNotEmpty) {
        try {
          final oldFileName = avatarUrl.value.split('/').last.split('?').first;
          debugPrint('Deleting old avatar: $oldFileName');
          await _errorService.retryOperation(
            operation: () =>
                _supabase.storage.from('avatars').remove([oldFileName]),
            maxRetries: 2,
          );
        } catch (e) {
          debugPrint('Error deleting old avatar: $e');
        }
      }

      // Upload new avatar with retry
      debugPrint('Uploading new avatar...');
      await _errorService.retryOperation(
        operation: () =>
            _supabase.storage.from('avatars').upload(filePath, optimizedImage),
        maxRetries: 3,
      );

      // Get public URL
      final publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(filePath);
      debugPrint('Avatar URL: $publicUrl');

      // Update user profile in database with retry
      await _errorService.retryOperation(
        operation: () => _supabase
            .from('users')
            .update({
              'avatar_url': publicUrl,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId),
        maxRetries: 3,
      );

      // Update local state
      avatarUrl.value = publicUrl;

      debugPrint('=== Avatar Uploaded Successfully ===');

      Get.snackbar(
        'Sukses',
        'Foto profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      debugPrint('=== Upload Avatar Error ===');
      debugPrint('Error: $e');

      _errorService.handleError(e);
      Get.snackbar(
        'Error',
        'Gagal mengupload foto profil. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  // Show image picker options
  void showImagePickerOptions() {
    debugPrint('=== Show Image Picker Options Called ===');
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF26A69A),
              ),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 300));
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF26A69A)),
              title: const Text('Ambil Foto'),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 300));
                takePhotoWithCamera();
              },
            ),
            if (avatarUrl.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Hapus Foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 300));
                  removeAvatar();
                },
              ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: false,
    );
  }

  // Remove avatar
  Future<void> removeAvatar() async {
    try {
      isUploadingAvatar.value = true;

      final userId = _authService.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      debugPrint('=== Removing Avatar ===');

      // Delete from storage
      if (avatarUrl.value.isNotEmpty) {
        final oldFileName = avatarUrl.value.split('/').last.split('?').first;
        debugPrint('Deleting avatar: $oldFileName');
        await _supabase.storage.from('avatars').remove([oldFileName]);
      }

      // Update database
      await _supabase
          .from('users')
          .update({
            'avatar_url': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Update local state
      avatarUrl.value = '';

      debugPrint('=== Avatar Removed Successfully ===');

      Get.snackbar(
        'Sukses',
        'Foto profil berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      debugPrint('=== Remove Avatar Error ===');
      debugPrint('Error: $e');
      Get.snackbar(
        'Error',
        'Gagal menghapus foto profil',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isUploadingAvatar.value = false;
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
