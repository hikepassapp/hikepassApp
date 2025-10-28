// lib/app/modules/register/controllers/register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
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

  Future<void> registerEmail() async {
    isLoading.value = true;
    print("✅ Mulai proses registrasi email...");
    await Future.delayed(const Duration(seconds: 2));

    Get.snackbar(
      'Berhasil',
      'Registrasi berhasil dilakukan!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
    );

    isLoading.value = false;
    print("✅ Navigasi ke /register-password...");
    Get.toNamed('/register-password');
  }

  Future<void> savePassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password tidak sama',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Error',
        'Password minimal 8 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implementasi API save password
      await Future.delayed(const Duration(seconds: 2));

      Get.toNamed('/register-otp');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Kode OTP tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implementasi API verify OTP
      await Future.delayed(const Duration(seconds: 2));

      Get.toNamed('/register/personal-data');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePersonalData() async {
    if (nikController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'NIK tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (namaLengkapController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama lengkap tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (teleponController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor telepon tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (tanggalLahirController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Tanggal lahir tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Jenis kelamin tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    if (alamatController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Alamat tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: Implementasi API save personal data
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Sukses',
        'Registrasi berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      // Navigate to home or login
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
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
