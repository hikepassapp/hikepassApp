// lib/app/modules/register/controllers/register_controller.dart

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../../../services/error_handling_service.dart';
import '../../../config/supabase_config.dart';
import '../../../utils/validators.dart';

class RegisterController extends GetxController {
  late final AuthService _authService;
  late final ErrorHandlingService _errorService;

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

  // OTP resend timer
  final otpCountdown = 0.obs;
  final canResendOtp = false.obs;
  Timer? _otpTimer;

  // Password validation
  final hasMinLength = false.obs;
  final hasUpperCase = false.obs;
  final hasLowerCase = false.obs;
  final hasNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _errorService = Get.find<ErrorHandlingService>();
    // Listen to password changes for validation
    passwordController.addListener(validatePassword);
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
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

  void startOtpTimer() {
    otpCountdown.value = 45;
    canResendOtp.value = false;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpCountdown.value > 0) {
        otpCountdown.value--;
      } else {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
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

    // Use advanced email validation
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        'Validasi Gagal',
        emailError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;

      // Check if email already exists in users table with retry
      final response = await _errorService.retryOperation(
        operation: () => SupabaseConfig.client
            .from('users')
            .select('email')
            .eq('email', email)
            .maybeSingle(),
        maxRetries: 3,
      );

      if (response != null) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Email sudah terdaftar. Silakan gunakan email lain atau login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 3),
        );
        return;
      }

      isLoading.value = false;
      Get.toNamed('/register-password');
    } catch (e) {
      isLoading.value = false;
      _errorService.handleError(e);
      Get.snackbar(
        'Error',
        'Gagal memeriksa email. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      debugPrint('Email check error: ${e.toString()}');
    }
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

    // Use advanced password validation
    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      Get.snackbar(
        'Validasi Gagal',
        passwordError,
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

      // Register with Supabase with retry mechanism
      final response = await _errorService.retryOperation(
        operation: () => _authService.signUpWithEmail(
          email: emailController.text.trim(),
          password: password,
          fullName: namaLengkapController.text.trim().isNotEmpty
              ? namaLengkapController.text.trim()
              : 'User',
          userType: userType.value,
          phoneNumber: teleponController.text.trim().isNotEmpty
              ? teleponController.text.trim()
              : null,
        ),
        maxRetries: 3,
      );

      if (response.user != null) {
        print('=== Registration Successful ===');
        print('User ID: ${response.user!.id}');

        // Send OTP to email for verification
        print('Sending OTP to email...');
        await _authService.sendOtpToEmail(email: emailController.text.trim());

        Get.snackbar(
          'Berhasil',
          'Akun berhasil dibuat! Kode OTP telah dikirim ke email Anda.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );

        // Start OTP countdown timer
        startOtpTimer();

        // Navigate to OTP verification page
        Get.toNamed('/register-otp');
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

        if (userType.value == 'pendaki') {
          Get.toNamed('/register-fill-data');
        } else {
          Get.offAllNamed('/login', arguments: {'userType': userType.value});
        }
      }
    } on AuthException catch (e) {
      String errorMessage = '';

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

  Future<void> resendOTP() async {
    if (!canResendOtp.value && otpCountdown.value > 0) {
      Get.snackbar(
        'Tunggu',
        'Mohon tunggu ${otpCountdown.value} detik sebelum mengirim ulang OTP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[900],
        duration: const Duration(seconds: 2),
      );
      return;
    }

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

      startOtpTimer();
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
    // Validate NIK
    final nikError = Validators.validateNIK(nikController.text.trim());
    if (nikError != null) {
      Get.snackbar(
        'Validasi Gagal',
        nikError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    // Validate name
    final nameError = Validators.validateName(
      namaLengkapController.text.trim(),
    );
    if (nameError != null) {
      Get.snackbar(
        'Validasi Gagal',
        nameError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    // Validate phone number
    final phoneError = Validators.validatePhoneNumber(
      teleponController.text.trim(),
    );
    if (phoneError != null) {
      Get.snackbar(
        'Validasi Gagal',
        phoneError,
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

    // Validate address
    final addressError = Validators.validateAddress(
      alamatController.text.trim(),
    );
    if (addressError != null) {
      Get.snackbar(
        'Validasi Gagal',
        addressError,
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

      // Update users table with retry
      print('Updating users table...');
      final usersResponse = await _errorService.retryOperation(
        operation: () => SupabaseConfig.client
            .from('users')
            .update({
              'full_name': namaLengkapController.text.trim(),
              'phone_number': teleponController.text.trim(),
            })
            .eq('id', userId)
            .select(),
        maxRetries: 3,
      );

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

      // UPSERT pendaki_profiles table (insert or update) with retry
      print('Upserting pendaki_profiles table...');
      final pendakiResponse = await _errorService.retryOperation(
        operation: () => SupabaseConfig.client.from('pendaki_profiles').upsert({
          'id': userId,
          'full_name': namaLengkapController.text.trim(),
          'nik': nikController.text.trim(),
          'phone_number': teleponController.text.trim(),
          'birth_date': birthDate,
          'gender': selectedGender.value,
          'full_address': alamatController.text.trim(),
        }).select(),
        maxRetries: 3,
      );

      print('Pendaki profiles upserted: $pendakiResponse');

      if (pendakiResponse.isEmpty) {
        throw Exception('Failed to save pendaki profile data');
      }

      print('=== Data Saved Successfully ===');

      // Clear all registration data
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      nikController.clear();
      namaLengkapController.clear();
      teleponController.clear();
      alamatController.clear();
      tanggalLahirController.clear();
      selectedGender.value = '';

      // Stop loading
      isLoading.value = false;

      // Show success message
      Get.snackbar(
        'Registrasi Berhasil! 🎉',
        'Akun Anda telah dibuat. Silakan login untuk melanjutkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );

      // Wait for snackbar to show
      await Future.delayed(const Duration(milliseconds: 1000));

      // Clear all routes and go back to landing screen
      Get.offAllNamed('/landing-screen');
    } catch (e) {
      print('=== Save Personal Data Error ===');
      print('Error type: ${e.runtimeType}');
      print('Error details: $e');

      _errorService.handleError(e);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan data. Silakan coba lagi.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Save personal data error: ${e.toString()}');
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
