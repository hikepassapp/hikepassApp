import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';

class LoginController extends GetxController {
  // Text Controllers
  late final AuthService _authService;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final resetOtpController = TextEditingController();

  // Observable States
  final isPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmNewPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoginLoading = false.obs;
  final isOtpLoading = false.obs;
  final isOtpValid = false.obs;
  final otpError = ''.obs;
  final isResetLoading = false.obs;
  final isResetOtpLoading = false.obs;
  final isResetOtpValid = false.obs;
  final resetOtpError = ''.obs;

  // Password validation for reset
  final hasMinLengthNewPassword = false.obs;
  final hasUpperCaseNewPassword = false.obs;
  final hasLowerCaseNewPassword = false.obs;
  final hasNumberNewPassword = false.obs;

  // User type (pendaki/pengelola)
  final userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    if (Get.arguments != null && Get.arguments['userType'] != null) {
      userType.value = Get.arguments['userType'];
    }
  }

  // Toggle password visibility for reset
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  // Validate new password strength
  void validateNewPassword() {
    final password = newPasswordController.text;
    hasMinLengthNewPassword.value = password.length >= 8;
    hasUpperCaseNewPassword.value = password.contains(RegExp(r'[A-Z]'));
    hasLowerCaseNewPassword.value = password.contains(RegExp(r'[a-z]'));
    hasNumberNewPassword.value = password.contains(RegExp(r'[0-9]'));
  }

  // Check if new password is strong enough
  bool get isNewPasswordStrong {
    return hasMinLengthNewPassword.value &&
        hasUpperCaseNewPassword.value &&
        hasLowerCaseNewPassword.value &&
        hasNumberNewPassword.value;
  }

  // Send OTP for password reset
  Future<void> sendResetOtp() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon masukkan password.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!isNewPasswordStrong) {
      Get.snackbar(
        'Error',
        'Password harus minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password tidak sama.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isResetLoading.value = true;

      final email = emailController.text.trim();

      debugPrint('=== Sending Reset OTP ===');
      debugPrint('Email: $email');

      // Send OTP to email
      await _authService.sendOtpToEmail(email: email);

      Get.snackbar(
        'Berhasil',
        'Kode OTP telah dikirim ke email Anda.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );

      // Navigate to OTP verification
      Get.toNamed('/login-otp-reset-password');
    } on AuthException catch (e) {
      debugPrint('=== Send Reset OTP Error ===');
      debugPrint('Error: ${e.message}');

      String errorMessage = 'Gagal mengirim OTP.';

      if (e.message.contains('rate limit')) {
        errorMessage = 'Terlalu banyak permintaan. Tunggu beberapa saat.';
      } else if (e.message.contains('not found')) {
        errorMessage = 'Email tidak terdaftar.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      debugPrint('Send reset OTP error: ${e.toString()}');
    } finally {
      isResetLoading.value = false;
    }
  }

  // Verify OTP and update password
  Future<void> verifyResetOtp() async {
    final otp = resetOtpController.text.trim();

    if (otp.length != 6) {
      resetOtpError.value = 'Kode OTP harus 6 digit';
      return;
    }

    try {
      isResetOtpLoading.value = true;
      resetOtpError.value = '';

      final email = emailController.text.trim();
      final newPassword = newPasswordController.text.trim();

      debugPrint('=== Verifying Reset OTP ===');
      debugPrint('Email: $email');
      debugPrint('OTP: $otp');

      // Verify OTP
      final response = await _authService.verifyOtp(
        email: email,
        token: otp,
      );

      if (response.user != null) {
        debugPrint('✅ OTP Verified! Updating password...');

        // Update password
        await _authService.updatePassword(newPassword: newPassword);

        debugPrint('✅ Password updated successfully!');

        Get.snackbar(
          'Berhasil',
          'Password berhasil direset! Silakan login dengan password baru.',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );

        // Clear all fields
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        resetOtpController.clear();

        // Navigate to landing screen
        Get.offAllNamed('/landing-screen');
      }
    } on AuthException catch (e) {
      debugPrint('=== Verify Reset OTP Error ===');
      debugPrint('Error: ${e.message}');

      if (e.message.contains('expired')) {
        resetOtpError.value = 'Kode OTP sudah kadaluarsa';
      } else if (e.message.contains('invalid')) {
        resetOtpError.value = 'Kode OTP tidak valid';
      } else {
        resetOtpError.value = 'Gagal verifikasi OTP';
      }
    } catch (e) {
      resetOtpError.value = 'Terjadi kesalahan. Silakan coba lagi.';
      debugPrint('Verify reset OTP error: ${e.toString()}');
    } finally {
      isResetOtpLoading.value = false;
    }
  }

  // Resend reset OTP
  Future<void> resendResetOtp() async {
    try {
      final email = emailController.text.trim();

      await _authService.sendOtpToEmail(email: email);

      Get.snackbar(
        'Berhasil',
        'Kode OTP telah dikirim ulang.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 2),
      );

      // Clear previous OTP
      resetOtpController.clear();
      resetOtpError.value = '';
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengirim ulang OTP.';

      if (e.message.contains('rate limit')) {
        errorMessage = 'Tunggu beberapa saat sebelum kirim ulang.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Navigate to reset password page
  void navigateToResetPassword() {
    final email = emailController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Mohon masukkan email yang valid terlebih dahulu.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    // Navigate to reset password view
    Get.toNamed('/login-reset-password');
  }

  // Old reset password dialog (kept for compatibility)
  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon masukkan email terlebih dahulu.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isResetLoading.value = true;

      await _authService.resetPassword(email: email);

      Get.back(); // Close dialog
      Get.snackbar(
        'Berhasil',
        'Email reset password telah dikirim! Cek inbox atau spam email Anda.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 5),
      );
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengirim email reset password.';

      if (e.message.contains('not found')) {
        errorMessage = 'Email tidak terdaftar.';
      } else if (e.message.contains('rate limit')) {
        errorMessage = 'Terlalu banyak permintaan. Tunggu beberapa saat.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      debugPrint('Reset password error: ${e.toString()}');
    } finally {
      isResetLoading.value = false;
    }
  }

  // Show reset password dialog
  void showResetPasswordDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Reset Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kami akan mengirim link reset password ke email:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Text(
              emailController.text.trim(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26A69A),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pastikan email Anda benar dan cek inbox atau folder spam.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Obx(() => ElevatedButton(
                onPressed: isResetLoading.value ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26A69A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isResetLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Kirim',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              )),
        ],
      ),
    );
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Check if email exists (Step 1)
  Future<void> checkEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon masukkan email.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed('/login-password');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Login with Supabase (Step 2)
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon masukkan password.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoginLoading.value = true;

      debugPrint('=== LOGIN ATTEMPT ===');
      debugPrint('Email: $email');

      // Sign in with Supabase
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      debugPrint('Login Response:');
      debugPrint('User ID: ${response.user?.id}');
      debugPrint('Email: ${response.user?.email}');
      debugPrint('Email Confirmed At: ${response.user?.emailConfirmedAt}');
      debugPrint('Created At: ${response.user?.createdAt}');

      if (response.user != null) {
        // Check if email is confirmed
        if (response.user!.emailConfirmedAt == null) {
          debugPrint('⚠️ EMAIL NOT CONFIRMED!');
          Get.snackbar(
            'Email Belum Dikonfirmasi',
            'Silakan konfirmasi email Anda terlebih dahulu. Cek inbox atau spam email Anda.',
            backgroundColor: Colors.orange[100],
            colorText: Colors.orange[900],
            duration: const Duration(seconds: 5),
          );
          return;
        }

        debugPrint('✅ Login successful! Navigating to home...');
        
        // Navigate directly to home (skip OTP for now)
        Get.snackbar(
          'Berhasil',
          'Login berhasil! Selamat datang.',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 2),
        );
        
        Get.offAllNamed('/bottom-navigation');
      }
    } on AuthException catch (e) {
      debugPrint('=== AUTH EXCEPTION ===');
      debugPrint('Status Code: ${e.statusCode}');
      debugPrint('Message: ${e.message}');
      
      String errorMessage = _handleAuthError(e);

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on TimeoutException catch (_) {
      Get.snackbar(
        'Error',
        'Koneksi timeout. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Login error: ${e.toString()}');
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Send OTP to user's email
  Future<void> sendOtp() async {
    try {
      final email = emailController.text.trim();

      // Send OTP via Supabase
      await _authService.sendOtpToEmail(email: email);

      Get.snackbar(
        'Success',
        'Kode OTP telah dikirim ke email Anda',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengirim OTP.';

      if (e.message.contains('rate limit')) {
        errorMessage = 'Terlalu banyak permintaan. Tunggu beberapa saat.';
      } else if (e.message.contains('invalid')) {
        errorMessage = 'Email tidak valid.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim OTP. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Send OTP error: ${e.toString()}');
    }
  }

  // Validate OTP input
  void validateOtp(String otp) {
    if (otp.length == 6) {
      isOtpValid.value = true;
      otpError.value = '';
    } else {
      isOtpValid.value = false;
      if (otp.isNotEmpty) {
        otpError.value = 'Kode OTP harus 6 digit';
      } else {
        otpError.value = '';
      }
    }
  }

  // Verify OTP (Step 3)
  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      otpError.value = 'Kode OTP harus 6 digit';
      return;
    }

    try {
      isOtpLoading.value = true;

      // Verify OTP with Supabase
      final response = await _authService.verifyOtp(email: email, token: otp);

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Verifikasi OTP berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 3),
        );

        // Navigate based on user type
        if (userType.value == 'pendaki') {
          Get.offAllNamed('/home');
        }
        // } else if (userType.value == 'pengelola') {
        //   Get.offAllNamed('/pengelola/home');
        // }
        else {
          Get.offAllNamed('/pendaki/home'); // Default
        }
      }
    } on AuthException catch (e) {
      final message = e.message.toLowerCase();

      if (message.contains('expired')) {
        otpError.value = 'Kode OTP sudah kadaluarsa. Silakan minta kode baru.';
      } else if (message.contains('invalid')) {
        otpError.value = 'Kode OTP tidak valid. Periksa kembali kode Anda.';
      } else if (message.contains('too many')) {
        otpError.value = 'Terlalu banyak percobaan. Tunggu beberapa saat.';
      } else {
        otpError.value = e.message;
      }

      isOtpValid.value = false;

      Get.snackbar(
        'Error',
        otpError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      otpError.value = 'Tidak ada koneksi internet.';
      isOtpValid.value = false;

      Get.snackbar(
        'Error',
        otpError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      otpError.value = 'Kode OTP tidak valid atau sudah kadaluarsa';
      isOtpValid.value = false;

      Get.snackbar(
        'Error',
        otpError.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('OTP verification error: ${e.toString()}');
    } finally {
      isOtpLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    try {
      isOtpLoading.value = true;

      // Resend OTP via Supabase
      await sendOtp();
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengirim ulang OTP.';

      if (e.message.contains('rate limit')) {
        errorMessage = 'Terlalu banyak permintaan. Tunggu beberapa saat.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } on SocketException catch (_) {
      Get.snackbar(
        'Error',
        'Tidak ada koneksi internet.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang OTP. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
      debugPrint('Resend OTP error: ${e.toString()}');
    } finally {
      isOtpLoading.value = false;
    }
  }

  // Helper method to handle authentication errors
  String _handleAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login') ||
        message.contains('invalid credentials')) {
      return 'Email atau password salah. Silakan coba lagi.';
    } else if (message.contains('email not confirmed')) {
      return 'Email belum diverifikasi. Periksa inbox Anda untuk link verifikasi.';
    } else if (message.contains('user not found')) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    } else if (message.contains('too many requests')) {
      return 'Terlalu banyak percobaan login. Tunggu beberapa saat.';
    } else if (message.contains('network')) {
      return 'Masalah koneksi jaringan. Periksa internet Anda.';
    } else if (message.contains('timeout')) {
      return 'Koneksi timeout. Silakan coba lagi.';
    } else if (message.contains('account locked') ||
        message.contains('suspended')) {
      return 'Akun Anda telah diblokir. Hubungi administrator.';
    } else if (message.contains('password')) {
      return 'Password salah. Silakan coba lagi atau reset password Anda.';
    }

    return 'Terjadi kesalahan saat login. Silakan coba lagi.';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
