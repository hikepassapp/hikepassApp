import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/auth_service.dart';
import '../../../services/error_handling_service.dart';
import '../../../utils/validators.dart';

class LoginController extends GetxController {
  // Text Controllers
  late final AuthService _authService;
  late final ErrorHandlingService _errorService;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final resetOtpController = TextEditingController();

  // Observable States
  final isPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmNewPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoginLoading = false.obs;
  // REMOVED OTP: Comment out OTP-related observables
  // final isOtpLoading = false.obs;
  // final isOtpValid = false.obs;
  // final otpError = ''.obs;
  final isResetLoading = false.obs;

  // OTP resend timer for password reset
  final resetOtpCountdown = 0.obs;
  final canResendResetOtp = false.obs;
  Timer? _resetOtpTimer;

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
    _errorService = Get.find<ErrorHandlingService>();
    if (Get.arguments != null && Get.arguments['userType'] != null) {
      userType.value = Get.arguments['userType'];
    }
    // Add listener for new password validation
    newPasswordController.addListener(validateNewPassword);
  }

  void startResetOtpTimer() {
    resetOtpCountdown.value = 60;
    canResendResetOtp.value = false;
    _resetOtpTimer?.cancel();
    _resetOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resetOtpCountdown.value > 0) {
        resetOtpCountdown.value--;
      } else {
        canResendResetOtp.value = true;
        timer.cancel();
      }
    });
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

  // REMOVED OTP: Comment out sendResetOtp method
  /*
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
  */

  // REMOVED OTP: Comment out verifyResetOtp method
  /*
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
  */

  // REMOVED OTP: Comment out resendResetOtp method
  /*
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
  */

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

      Get.back(); 
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

  // Direct password reset - now sends OTP
  Future<void> resetPasswordDirect() async {
    print('=== START RESET PASSWORD (SEND OTP) ===');

    final email = emailController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmNewPasswordController.text.trim();

    print('Email: $email');
    print('New Password Length: ${newPassword.length}');
    print('Confirm Password Length: ${confirmPassword.length}');
    print('Is Password Strong: $isNewPasswordStrong');

    if (email.isEmpty) {
      print('ERROR: Email is empty');
      Get.snackbar(
        'Error',
        'Email tidak ditemukan.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      print('ERROR: Password fields are empty');
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (!isNewPasswordStrong) {
      print('ERROR: Password not strong enough');
      print('Min Length: ${hasMinLengthNewPassword.value}');
      print('Has Uppercase: ${hasUpperCaseNewPassword.value}');
      print('Has Lowercase: ${hasLowerCaseNewPassword.value}');
      print('Has Number: ${hasNumberNewPassword.value}');
      Get.snackbar(
        'Error',
        'Password harus minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (newPassword != confirmPassword) {
      print('ERROR: Passwords do not match');
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
      print('Sending password reset OTP to email...');

      // Send password reset OTP to email
      await _authService.sendPasswordResetOtp(email: email);

      print('SUCCESS: Password reset link sent to email');

      Get.snackbar(
        'OTP Terkirim',
        'Kode OTP telah dikirim ke email Anda. Silakan cek inbox atau folder spam.',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );

      // Start countdown timer
      startResetOtpTimer();

      // Navigate to OTP verification page
      Get.toNamed('/login-otp-reset-password');
    } on AuthException catch (e) {
      print('=== AUTH EXCEPTION ===');
      print('Error Message: ${e.message}');
      print('Error Code: ${e.statusCode}');
      print('Full Error: $e');

      String errorMessage = 'Gagal mengirim OTP.';

      if (e.message.contains('not found')) {
        errorMessage = 'Email tidak terdaftar.';
      } else if (e.message.contains('rate')) {
        errorMessage = 'Terlalu banyak permintaan. Tunggu beberapa saat.';
      } else if (e.message.contains('magic link')) {
        errorMessage =
            'Gagal mengirim email. Periksa konfigurasi SMTP Anda di Supabase Dashboard → Authentication → Email Templates → SMTP Settings.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      print('=== GENERAL EXCEPTION ===');
      print('Error Type: ${e.runtimeType}');
      print('Error Details: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isResetLoading.value = false;
      print('=== END RESET PASSWORD (SEND OTP) ===');
    }
  }

  // Verify OTP and update password
  Future<void> verifyOtpAndResetPassword() async {
    print('=== START VERIFY OTP AND RESET PASSWORD ===');

    final email = emailController.text.trim();
    final otp = resetOtpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    print('Email: $email');
    print('OTP Length: ${otp.length}');

    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Kode OTP harus 6 digit',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isResetLoading.value = true;

      // Verify OTP - this creates an authenticated session
      await _authService.verifyOtp(email: email, token: otp);

      print('OTP verified successfully');

      // Update password using the session created by OTP verification
      await _authService.updatePassword(newPassword: newPassword);

      print('SUCCESS: Password updated');

      // Stop loading first
      isResetLoading.value = false;

      // Clear all form fields
      emailController.clear();
      resetOtpController.clear();
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // Show success message
      Get.snackbar(
        'Berhasil! 🎉',
        'Password berhasil direset. Silakan login dengan password baru.',
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
    } on AuthException catch (e) {
      print('=== AUTH EXCEPTION ===');
      print('Error: ${e.message}');

      String errorMessage = 'Gagal memverifikasi OTP.';

      if (e.message.contains('expired')) {
        errorMessage = 'Kode OTP sudah expired. Silakan kirim ulang.';
      } else if (e.message.contains('invalid')) {
        errorMessage = 'Kode OTP salah. Silakan cek kembali.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } catch (e) {
      print('=== GENERAL EXCEPTION ===');
      print('Error: $e');

      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isResetLoading.value = false;
      print('=== END VERIFY OTP AND RESET PASSWORD ===');
    }
  }

  // Show reset password dialog
  void showResetPasswordDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kami akan mengirim link reset password ke email:',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          Obx(
            () => ElevatedButton(
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Kirim',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
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

    // Validate email
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        'Validasi Gagal',
        emailError,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

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

      // Sign in with Supabase with retry mechanism
      final response = await _errorService.retryOperation(
        operation: () =>
            _authService.signInWithEmail(email: email, password: password),
        maxRetries: 3,
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
        );

        await Future.delayed(const Duration(milliseconds: 800));

        Get.offAllNamed('/bottom-navigation');
      }
    } catch (e) {
      debugPrint('=== LOGIN ERROR ===');
      debugPrint('Error: $e');

      _errorService.handleError(e);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat login. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  // REMOVED OTP: Comment out sendOtp method
  /*
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
  */

  // REMOVED OTP: Comment out validateOtp method
  /*
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
  */

  // REMOVED OTP: Comment out verifyOtp method
  /*
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
  */

  // REMOVED OTP: Comment out resendOtp method
  /*
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
  */

  @override
  void onClose() {
    _resetOtpTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    resetOtpController.dispose();
    super.onClose();
  }
}
