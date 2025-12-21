// lib/app/modules/register/controllers/register_controller.dart

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../../../config/supabase_config.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final nikController = TextEditingController();
  final namaLengkapController = TextEditingController();
  final teleponController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final alamatController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final selectedGender = ''.obs;
  final userType = 'pendaki'.obs; // Default to pendaki
  final agreeToTerms = false.obs;

  // Password validation
  final hasMinLength = false.obs;
  final hasUpperCase = false.obs;
  final hasLowerCase = false.obs;
  final hasNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to password changes for validation
    passwordController.addListener(validatePassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    nikController.dispose();
    namaLengkapController.dispose();
    teleponController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  void setUserType(String type) {
    userType.value = type;
  }

  // Validate password strength
  void validatePassword() {
    final password = passwordController.text;
    hasMinLength.value = password.length >= 8;
    hasUpperCase.value = password.contains(RegExp(r'[A-Z]'));
    hasLowerCase.value = password.contains(RegExp(r'[a-z]'));
    hasNumber.value = password.contains(RegExp(r'[0-9]'));
  }

  // Check if password is strong enough
  bool get isPasswordStrong {
    return hasMinLength.value &&
        hasUpperCase.value &&
        hasLowerCase.value &&
        hasNumber.value;
  }

  // Step 1: Register Email
  Future<void> registerEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon masukkan email.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    Get.toNamed('/register-password');
  }

  // Step 2: Save Password and Create Account
  Future<void> savePassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!isPasswordStrong) {
      Get.snackbar(
        'Error',
        'Password harus minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password tidak sama',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;

      print('=== Starting Registration ===');
      print('Email: ${emailController.text.trim()}');
      print('User Type: ${userType.value}');

      // Register with Supabase
      final response = await _authService.signUpWithEmail(
        email: emailController.text.trim(),
        password: password,
        fullName: namaLengkapController.text.trim().isNotEmpty
            ? namaLengkapController.text.trim()
            : 'User',
        userType: userType.value,
        phoneNumber: teleponController.text.trim().isNotEmpty
            ? teleponController.text.trim()
            : null,
      );

      if (response.user != null) {
        print('=== Registration Successful ===');
        print('User ID: ${response.user!.id}');

        // Wait a bit before sending OTP to avoid rate limit
        await Future.delayed(const Duration(seconds: 2));

        // Try to send OTP
        try {
          await _authService.sendOtpToEmail(email: emailController.text.trim());

          Get.snackbar(
            'Berhasil',
            'Akun berhasil dibuat! Kode OTP telah dikirim ke email Anda.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: const Duration(seconds: 3),
          );

          Get.toNamed('/register-otp');
        } catch (otpError) {
          print('OTP Error: $otpError');
          // If OTP sending fails due to rate limit, show message but still proceed
          if (otpError.toString().contains('60 seconds') ||
              otpError.toString().contains('rate limit') ||
              otpError.toString().contains('security purposes')) {
            Get.snackbar(
              'Informasi',
              'Akun berhasil dibuat! Mohon tunggu 60 detik sebelum meminta kode OTP.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange[100],
              colorText: Colors.orange[900],
              duration: const Duration(seconds: 4),
            );

            // Still navigate to OTP page, user can resend after 60 seconds
            Get.toNamed('/register-otp');
          } else {
            rethrow;
          }
        }
      }
    } on AuthException catch (e) {
      String errorMessage = _handleAuthError(e);

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on PostgrestException catch (e) {
      print('Database error: ${e.message}');
      String errorMessage = 'Terjadi kesalahan database.';

      if (e.code == '23505') {
        if (e.message.contains('email')) {
          errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
        } else if (e.message.contains('nik')) {
          errorMessage = 'NIK sudah terdaftar.';
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on TimeoutException catch (_) {
      Get.snackbar(
        'Error',
        'Koneksi timeout. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('Register error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Register error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Verify OTP
  Future<void> verifyOTP() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar(
        'Error',
        'Kode OTP tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Kode OTP harus 6 digit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;

      // Verify OTP with Supabase
      final response = await _authService.verifyOtp(email: email, token: otp);

      if (response.user != null) {
        Get.snackbar(
          'Berhasil',
          'Verifikasi OTP berhasil!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );

        // If pendaki, go to fill data page, else go to login
        if (userType.value == 'pendaki') {
          Get.toNamed('/register-fill-data');
        } else {
          Get.offAllNamed('/login', arguments: {'userType': userType.value});
        }
      }
    } on AuthException catch (e) {
      String errorMessage='';

      if (e.message.contains('expired')) {
        errorMessage = 'Kode OTP sudah kadaluarsa. Silakan minta kode baru.';
      } else if (e.message.contains('invalid')) {
        errorMessage =
            'Kode OTP tidak valid. Periksa kembali kode yang Anda masukkan.';
      } else if (e.message.contains('too many')) {
        errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet. Periksa koneksi Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('OTP verification error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    try {
      isLoading.value = true;

      await _authService.sendOtpToEmail(email: emailController.text.trim());

      Get.snackbar(
        'Berhasil',
        'Kode OTP telah dikirim ulang ke email Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengirim ulang OTP.';

      if (e.message.contains('rate limit') ||
          e.message.contains('60 seconds') ||
          e.message.contains('security purposes')) {
        errorMessage = 'Mohon tunggu 60 detik sebelum meminta kode OTP baru.';
      } else if (e.message.contains('too many requests')) {
        errorMessage = 'Terlalu banyak permintaan. Mohon tunggu beberapa saat.';
      } else if (e.message.contains('invalid email')) {
        errorMessage = 'Email tidak valid.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang OTP. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Resend OTP error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Step 4: Save Pendaki Personal Data
  Future<void> savePersonalData() async {
    if (nikController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'NIK tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (namaLengkapController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama lengkap tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (teleponController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor telepon tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (tanggalLahirController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Tanggal lahir tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Jenis kelamin tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (alamatController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Alamat tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;

      final userId = _authService.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('=== Saving Personal Data ===');
      print('User ID: $userId');
      print('Full Name: ${namaLengkapController.text.trim()}');
      print('Phone: ${teleponController.text.trim()}');
      print('NIK: ${nikController.text.trim()}');

      // Update users table
      print('Updating users table...');
      final usersResponse = await SupabaseConfig.client
          .from('users')
          .update({
            'full_name': namaLengkapController.text.trim(),
            'phone_number': teleponController.text.trim(),
          })
          .eq('id', userId)
          .select();

      print('Users table updated: $usersResponse');

      // Convert date format from "DD / MM / YYYY" to "YYYY-MM-DD"
      String? birthDate;
      if (tanggalLahirController.text.isNotEmpty) {
        try {
          final parts = tanggalLahirController.text.trim().split('/');
          if (parts.length == 3) {
            final day = parts[0].trim().padLeft(2, '0');
            final month = parts[1].trim().padLeft(2, '0');
            final year = parts[2].trim();
            birthDate = '$year-$month-$day';
          }
        } catch (e) {
          print('Error parsing date: $e');
        }
      }

      // UPSERT pendaki_profiles table (insert or update)
      print('Upserting pendaki_profiles table...');
      final pendakiResponse =
          await SupabaseConfig.client.from('pendaki_profiles').upsert({
            'id': userId,
            'full_name': namaLengkapController.text.trim(),
            'nik': nikController.text.trim(),
            'phone_number': teleponController.text.trim(),
            'birth_date': birthDate,
            'gender': selectedGender.value,
            'full_address': alamatController.text.trim(),
          }).select();

      print('Pendaki profiles upserted: $pendakiResponse');

      if (pendakiResponse.isEmpty) {
        throw Exception('Failed to save pendaki profile data');
      }

      print('=== Data Saved Successfully ===');

      Get.snackbar(
        'Sukses',
        'Registrasi berhasil! Selamat datang di HikePass!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );

      // Navigate to home page based on user type
      await Future.delayed(const Duration(seconds: 2));

      try {
        // Check if routes exist and navigate
        if (userType.value == 'pendaki') {
          Get.offAllNamed('/home');
          // } else if (userType.value == 'pengelola') {
          //   Get.offAllNamed('/pengelola/home');
          //
        } else {
          // Fallback to any existing home route
          Get.offAllNamed('/home');
        }
      } catch (navigationError) {
        print('Navigation error: $navigationError');
        // If navigation fails, try alternative route
        try {
          Get.offAllNamed('/home');
        } catch (e) {
          print('Fallback navigation also failed: $e');
          // Just clear the loading state, user is already registered
          Get.back();
        }
      }
    } on PostgrestException catch (e) {
      String errorMessage = 'Gagal menyimpan data.';

      if (e.message.contains('duplicate')) {
        errorMessage = 'NIK sudah terdaftar. Gunakan NIK yang berbeda.';
      } else if (e.message.contains('foreign key')) {
        errorMessage = 'Data tidak valid. Silakan coba lagi.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet. Data akan disimpan setelah koneksi pulih.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('=== Save Personal Data Error ===');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan data. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Save personal data error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to handle authentication errors
  String _handleAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('already') || message.contains('registered')) {
      return 'Email sudah terdaftar. Silakan gunakan email lain atau login.';
    } else if (message.contains('invalid email')) {
      return 'Format email tidak valid.';
    } else if (message.contains('weak password')) {
      return 'Password terlalu lemah. Gunakan kombinasi huruf besar, kecil, dan angka.';
    } else if (message.contains('network')) {
      return 'Masalah koneksi jaringan. Periksa internet Anda.';
    } else if (message.contains('timeout')) {
      return 'Koneksi timeout. Silakan coba lagi.';
    } else if (message.contains('rate limit')) {
      return 'Terlalu banyak percobaan. Tunggu beberapa saat.';
    } else if (message.contains('user not found')) {
      return 'Pengguna tidak ditemukan.';
    } else if (message.contains('email not confirmed')) {
      return 'Email belum diverifikasi. Periksa inbox Anda.';
    }

    return e.message;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF059669)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      tanggalLahirController.text =
          '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
    }
  }
}
