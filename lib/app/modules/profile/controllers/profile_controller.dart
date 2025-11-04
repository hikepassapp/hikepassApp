import 'package:flutter/painting.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
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

  var termsAccepted = false.obs;
  var privacyPolicyAccepted = false.obs;
  var aboutTicketViewed = false.obs;

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

  // Update profile
  void updateProfile() {
    Get.back();
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
        Get.back();
        Get.offAllNamed('/login');
      },
    );
  }
}
