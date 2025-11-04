import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

enum HikeType { checkIn, checkOut }

class HikingItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final String imagePath;
  final HikeType type;

  HikingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.imagePath,
    required this.type,
  });

  HikingItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? date,
    String? imagePath,
    HikeType? type,
  }) {
    return HikingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
    );
  }
}

class HikingController extends GetxController {
  final tabIndex = 0.obs;
  final TextEditingController listController = TextEditingController();
  final RxList<HikingItem> _allItems = <HikingItem>[].obs;
  final Rxn<HikingItem> selectedItem = Rxn<HikingItem>();

  @override
  void onInit() {
    super.onInit();
    _allItems.addAll([
      HikingItem(
        id: 'malabar-20251104',
        title: 'Puncak Besar Malabar',
        subtitle: 'Jalur Panorama',
        date: DateTime(2025, 11, 4),
        imagePath: 'assets/images/reservasi_panorama.png',
        type: HikeType.checkIn,
      ),
    ]);
  }

  List<HikingItem> get filtered {
    final type = tabIndex.value == 0 ? HikeType.checkIn : HikeType.checkOut;
    return _allItems.where((item) => item.type == type).toList();
  }

  void switchTab(int index) {
    if (tabIndex.value != index) tabIndex.value = index;
  }
  void selectItem(HikingItem item) {
    selectedItem.value = item;
  }

  void submitCheckInAndGoToCheckout() {
    if (listController.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Mohon isi list barang bawaan',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final current = selectedItem.value;
    if (current != null) {
      final idx = _allItems.indexWhere((e) => e.id == current.id);
      if (idx != -1) {
        _allItems[idx] = _allItems[idx].copyWith(type: HikeType.checkOut);
      }
      selectedItem.value = null;
    }

    listController.clear();
    Get.back();

    Get.snackbar('Berhasil', 'Check-in berhasil dilakukan',
        backgroundColor: AppColors.primary, colorText: Colors.white);

    switchTab(1); 
  }

  void submitCheckOutAndFinish() {
    if (listController.text.trim().isEmpty) {
      Get.snackbar('Perhatian', 'Mohon isi list barang bawaan',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    final current = selectedItem.value;
    if (current != null) {
      _allItems.removeWhere((e) => e.id == current.id);
      selectedItem.value = null;
    }

    listController.clear();
    Get.back();

    Get.snackbar('Selesai', 'Check-out berhasil dicatat',
        backgroundColor: AppColors.primary, colorText: Colors.white);

    switchTab(1);
  }

}
