import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  // Observable States
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoginLoading = false.obs;
  final isOtpLoading = false.obs;
  final isOtpValid = false.obs;
  final otpError = ''.obs;

  // User type (pendaki/pengelola)
  final userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['userType'] != null) {
      userType.value = Get.arguments['userType'];
    }
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

  Future<void> login() async {
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
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed('/login-otp');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan. Silakan coba lagi.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
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

  // Verify OTP (Step 2B)
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      otpError.value = 'Kode OTP harus 6 digit';
      return;
    }

    try {
      isOtpLoading.value = true;
      await Future.delayed(Duration(seconds: 2));
      if (otp == '123456') {
        Get.snackbar(
          'Success',
          'Verifikasi OTP berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );

        // Navigate based on user type
        if (userType.value == 'pendaki') {
          Get.offAllNamed('/pendaki/home');
        } else if (userType.value == 'pengelola') {
          Get.offAllNamed('/pengelola/home');
        } else {
          Get.offAllNamed('/pendaki/home'); // Default
        }
      } else {
        otpError.value = 'Kode OTP tidak valid';
        isOtpValid.value = false;
      }
    } catch (e) {
      otpError.value = 'Terjadi kesalahan. Silakan coba lagi.';
    } finally {
      isOtpLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Kode OTP telah dikirim ulang',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim ulang OTP',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
