// lib/app/modules/landingScreen/controllers/landing_screen_controller.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart'; // Pastikan path ini benar (level ../../../)
// Import the landing views so controller can navigate between them
import '../views/landing_screen_next_view.dart';
import '../views/landing_screen_last_view.dart';

class LandingScreenController extends GetxController {
  final PageController indicatorController = PageController();
  final RxInt currentPage = 0.obs;

  // --- DATA ---
  final List<Map<String, String>> pageData = const [
    {
      // --- PERIKSA INI ---
      // Pastikan Anda punya file bernama 'landing.png'
      // di dalam folder 'assets/images/'
      'image': 'assets/images/landing.png', // SAYA UBAH KE .png

      // --- PERIKSA INI ---
      'title': 'Daki Gunung, Jaga Alam',
      'description':
          'Jelajahi keindahan puncak Indonesia sambil menjaga keasrian hutan dan lingkungan sekitar.',
    },
    {
      'image': 'assets/images/hike2.jpg', // Pastikan file ini juga ada
      'title': 'Temukan Jalur Baru',
      'description':
          'Rencanakan pendakian Anda dengan peta dan panduan terpercaya.',
    },
    {
      'image': 'assets/images/hike3.jpg', // Pastikan file ini juga ada
      'title': 'Bergabung Komunitas',
      'description':
          'Bagikan pengalaman dan temukan teman baru sesama pendaki.',
    },
  ];

  // ... (Sisa kode controller Anda sama, tidak perlu diubah) ...
  @override
  void onClose() {
    indicatorController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    // If we're not at the last page, advance the logical page and navigate
    if (currentPage.value < pageData.length - 1) {
      currentPage.value++;
      // Navigate to the corresponding view
      if (currentPage.value == 1) {
        // go to second landing page
        Get.to(() => const LandingScreenNextView());
      } else if (currentPage.value == 2) {
        // go to third/last landing page
        Get.to(() => const LandingScreenLastView());
      }
    }
  }

  void skip() {
    Get.offAllNamed(Routes.login);
  }

  void getStarted() {
    Get.offAllNamed(Routes.register);
  }
}
