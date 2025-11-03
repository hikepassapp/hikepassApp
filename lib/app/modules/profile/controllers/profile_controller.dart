import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable variables
  var isEditing = false.obs;
  var nik = '920214217635218'.obs;
  var namaLengkap = 'Nailong'.obs;
  var kontak = '82256781111'.obs;
  var countryCode = '+62'.obs;
  var tanggalLahir = '04 / 04 / 2004'.obs;
  var usia = '21'.obs;
  var jenisKelamin = 'Laki-laki'.obs;
  var alamat =
      'Kost Adhyaksa III Jl, mangga II, kecamatan Bojongsoang, Kab. Bandung, 16210'
          .obs;
  var username = 'Nailong_imut'.obs;
  var email = 'nailong@gmail.com'.obs;

  // Terms & Conditions related variables (if needed in future)
  var termsAccepted = false.obs;

  // Privacy Policy related variables (if needed in future)
  var privacyPolicyAccepted = false.obs;

  // About Ticket related variables (if needed in future)
  var aboutTicketViewed = false.obs;

  // Toggle gender
  void setGender(String gender) {
    jenisKelamin.value = gender;
  }

  // Terms & Conditions methods
  void acceptTerms() {
    termsAccepted.value = true;
  }

  void viewTerms() {
    // Add any logic needed when terms are viewed
  }

  // Privacy Policy methods
  void acceptPrivacyPolicy() {
    privacyPolicyAccepted.value = true;
  }

  void viewPrivacyPolicy() {
    // Add any logic needed when privacy policy is viewed
  }

  // About Ticket methods
  void markAboutTicketAsViewed() {
    aboutTicketViewed.value = true;
  }

  void viewAboutTicket() {
    // Add any logic needed when about ticket is viewed
  }

  // Update profile
  void updateProfile() {
    // Logic untuk update profile
    Get.back(); // Kembali ke halaman profil
    Get.snackbar(
      'Berhasil',
      'Profile berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF179778),
      colorText: Color(0xFFFFFFFF),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  // Logout
  void logout() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah Anda yakin ingin keluar?',
      textConfirm: 'Ya',
      textCancel: 'Tidak',
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        // Logic logout
        Get.back();
        Get.offAllNamed('/login');
      },
    );
  }
}
