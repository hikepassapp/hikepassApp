import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  final List<HikingItem> _items = [
    HikingItem(
      title: 'Gunung Puntang',
      date: DateTime(2025, 10, 28),
      imagePath: 'assets/images/gunung-puntang.jpg',
      type: HikeType.checkIn,
    ),
  ];

  List<HikingItem> get filtered {
    final isCheckIn = tabIndex.value == 0;
    return _items.where((e) => isCheckIn ? e.type == HikeType.checkIn : e.type == HikeType.checkOut).toList();
  }

  void switchTab(int i) => tabIndex.value = i;

  final TextEditingController listController = TextEditingController();

  void submitCheckInAndGoToCheckout() {
    final text = listController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Peringatan', 'List barang tidak boleh kosong!');
      return;
    }

    tabIndex.value = 1; 
    Get.back();           
    Get.snackbar('Berhasil', 'Check-In berhasil disimpan!');
    listController.clear();
  }

  @override
  void onClose() {
    listController.dispose();
    super.onClose();
  }
}
