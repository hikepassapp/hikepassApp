import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

enum HikeType { checkIn, checkOut }

class HikingItem {
  final String title;
  final DateTime date;
  final String imagePath;
  final HikeType type;

  HikingItem({
    required this.title,
    required this.date,
    required this.imagePath,
    required this.type,
  });
}

class HikingController extends GetxController {
  final tabIndex = 0.obs;
  final TextEditingController listController = TextEditingController();
  final RxList<HikingItem> _allItems = <HikingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _allItems.addAll([
      HikingItem(
        title: 'Gunung Puntang',
        date: DateTime(2025, 10, 28),
        imagePath: 'assets/images/gunung-puntang.jpg',
        type: HikeType.checkIn,
      ),
    ]);
  }

  List<HikingItem> get filtered {
    final type = tabIndex.value == 0 ? HikeType.checkIn : HikeType.checkOut;
    return _allItems.where((item) => item.type == type).toList();
  }

  void switchTab(int index) {
    if (tabIndex.value != index) {
      tabIndex.value = index;
    }
  }

  void submitCheckInAndGoToCheckout() {
    if (listController.text.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Mohon isi list barang bawaan',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    listController.clear();
    Get.back();

    Get.snackbar(
      'Berhasil',
      'Check-in berhasil dilakukan',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
    );

    listController.clear();
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}
